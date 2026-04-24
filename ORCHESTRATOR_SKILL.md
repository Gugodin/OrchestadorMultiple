---
name: orchestrator-specialist
description: Patron de orquestacion secuencial por roles en Flutter con BLoC. Implementa una cola de tareas criticas/opcionales que se ejecutan en orden al iniciar sesion, con manejo de errores y reintento desde cero.
---

# Skill: Role-Based Orchestrator — Orquestacion Secuencial por Roles

Este manual define como construir un sistema de orquestacion de inicio de sesion basado en roles en Flutter. Al autenticarse, el rol del usuario determina una cola de tareas (feature BLoCs) que se ejecutan de forma **secuencial**. El sistema es abierto a extension: agregar un rol o una tarea requiere modificar unicamente el archivo de configuracion y el switch del widget orquestador.

---

## 1. Concepto Central

El patron resuelve el siguiente problema: al iniciar sesion, distintos roles requieren distintos modulos precargados antes de acceder al home. En vez de que cada pantalla decida que cargar (acoplamiento), un **orquestador central** recibe el rol y ejecuta su cola de tareas en orden.

### Flujo de navegacion

```
LoginScreen
    │
    └─ push ──► OrchestratorWidget(role)
                    │
                    ├─ [running] dispara feature BLoCs uno a uno
                    ├─ [failure] muestra error + boton reintento (desde cero)
                    │
                    └─ pushReplacement ──► RoleHomeScreen
                                                │
                                                └─ pop (logout) ──► LoginScreen
```

### Principio de criticidad

Cada tarea declara `isCritical`:
- `true` → si falla, la orquestacion se **detiene** y muestra pantalla de error.
- `false` → si falla, la tarea se **omite** y la orquestacion **continua**.

El reintento siempre **reinicia desde cero** (no desde donde fallo).

---

## 2. Estructura de Archivos

```
lib/
├── main.dart                          ← MultiBlocProvider global
├── orchestador_multiple/
│   ├── orchestrator_config.dart       ← Enums y mapa de configuracion
│   ├── orchestrator_widget.dart       ← MultiBlocListener + UI de carga
│   └── bloc/
│       ├── orchestrator_bloc.dart
│       ├── orchestrator_event.dart
│       └── orchestrator_state.dart
├── screens/
│   ├── login.dart
│   ├── gestor_home.dart
│   └── supervisor_home.dart
└── depending_blocs/
    ├── gestor/
    │   ├── asignations_bloc/
    │   ├── catalog_gestor_bloc/
    │   └── permissions_bloc/
    └── supervisor/
        ├── catalog_supervisor_bloc/
        └── gestors_bloc/
```

---

## 3. Archivo de Configuracion (`orchestrator_config.dart`)

Es el **unico lugar** donde se registran roles y tareas. Agregar un rol o tarea aqui propaga el cambio al resto del sistema.

```dart
// ============================================================
// Para AGREGAR UN NUEVO ROL:
//   1. Añade el valor en [UserRole]
//   2. Define sus tareas en [roleTasksConfig]
//
// Para AGREGAR UNA NUEVA TAREA:
//   1. Añade el valor en [OrchestratorTask] con isCritical y label
//   2. Agrégala a la lista del rol en [roleTasksConfig]
//   3. Agrega el case en el switch del OrchestratorWidget
// ============================================================

enum UserRole { gestor, supervisor }

enum OrchestratorTask {
  loadAsignations(isCritical: true,  label: 'Asignaciones'),
  loadCatalogGestor(isCritical: true,  label: 'Catálogo Gestor'),
  loadPermissions(isCritical: false, label: 'Permisos'),         // opcional
  loadGestors(isCritical: true,  label: 'Gestores'),
  loadCatalogSupervisor(isCritical: true,  label: 'Catálogo Supervisor');

  final bool isCritical;
  final String label;
  const OrchestratorTask({required this.isCritical, required this.label});
}

const Map<UserRole, List<OrchestratorTask>> roleTasksConfig = {
  UserRole.gestor: [
    OrchestratorTask.loadAsignations,
    OrchestratorTask.loadCatalogGestor,
    OrchestratorTask.loadPermissions,
  ],
  UserRole.supervisor: [
    OrchestratorTask.loadGestors,
    OrchestratorTask.loadCatalogSupervisor,
  ],
};
```

---

## 4. OrchestratorBloc

### 4.1 Eventos (`orchestrator_event.dart`)

```dart
part of 'orchestrator_bloc.dart';

@freezed
sealed class OrchestratorEvent with _$OrchestratorEvent {
  /// Inicia la orquestacion con la cola del [role].
  const factory OrchestratorEvent.started(UserRole role) = _Started;

  /// La tarea actual se completo exitosamente → avanzar a la siguiente.
  const factory OrchestratorEvent.taskCompleted() = _TaskCompleted;

  /// La tarea actual fallo con [error].
  /// Si es critica → detener. Si no → omitir y avanzar.
  const factory OrchestratorEvent.taskFailed(String error) = _TaskFailed;

  /// Reinicia desde cero (solo valido en estado failure).
  const factory OrchestratorEvent.retry() = _Retry;
}
```

### 4.2 Estados (`orchestrator_state.dart`)

```dart
part of 'orchestrator_bloc.dart';

@freezed
sealed class OrchestratorState with _$OrchestratorState {
  const factory OrchestratorState.initial() = _Initial;

  const factory OrchestratorState.running({
    required OrchestratorTask currentTask,
    required List<OrchestratorTask> pendingTasks,
    required int completedCount,
    required int totalCount,
    required UserRole role,
  }) = _Running;

  const factory OrchestratorState.success({required UserRole role}) = _Success;

  const factory OrchestratorState.failure({
    required OrchestratorTask failedTask,
    required String error,
    required UserRole role,
  }) = _Failure;
}
```

### 4.3 BLoC (`orchestrator_bloc.dart`)

```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../orchestrator_config.dart';

part 'orchestrator_event.dart';
part 'orchestrator_state.dart';
part 'orchestrator_bloc.freezed.dart';

class OrchestratorBloc extends Bloc<OrchestratorEvent, OrchestratorState> {
  OrchestratorBloc() : super(const OrchestratorState.initial()) {
    on<_Started>(_onStarted);
    on<_TaskCompleted>(_onTaskCompleted);
    on<_TaskFailed>(_onTaskFailed);
    on<_Retry>(_onRetry);
  }

  void _onStarted(_Started event, Emitter<OrchestratorState> emit) {
    final tasks = List<OrchestratorTask>.from(
      roleTasksConfig[event.role] ?? [],
    );
    if (tasks.isEmpty) {
      emit(OrchestratorState.success(role: event.role));
      return;
    }
    emit(OrchestratorState.running(
      currentTask: tasks.first,
      pendingTasks: tasks.sublist(1),
      completedCount: 0,
      totalCount: tasks.length,
      role: event.role,
    ));
  }

  void _onTaskCompleted(_TaskCompleted event, Emitter<OrchestratorState> emit) {
    if (state is! _Running) return;
    final current = state as _Running;
    final newCompleted = current.completedCount + 1;

    if (current.pendingTasks.isEmpty) {
      emit(OrchestratorState.success(role: current.role));
    } else {
      emit(OrchestratorState.running(
        currentTask: current.pendingTasks.first,
        pendingTasks: current.pendingTasks.sublist(1),
        completedCount: newCompleted,
        totalCount: current.totalCount,
        role: current.role,
      ));
    }
  }

  void _onTaskFailed(_TaskFailed event, Emitter<OrchestratorState> emit) {
    if (state is! _Running) return;
    final current = state as _Running;

    // Tarea critica → detener
    if (current.currentTask.isCritical) {
      emit(OrchestratorState.failure(
        failedTask: current.currentTask,
        error: event.error,
        role: current.role,
      ));
      return;
    }

    // Tarea opcional → omitir y avanzar
    final newCompleted = current.completedCount + 1;
    if (current.pendingTasks.isEmpty) {
      emit(OrchestratorState.success(role: current.role));
    } else {
      emit(OrchestratorState.running(
        currentTask: current.pendingTasks.first,
        pendingTasks: current.pendingTasks.sublist(1),
        completedCount: newCompleted,
        totalCount: current.totalCount,
        role: current.role,
      ));
    }
  }

  /// El retry re-despacha started con el rol guardado en el estado failure.
  /// Esto garantiza que siempre se reinicie desde cero, nunca desde el punto de fallo.
  void _onRetry(_Retry event, Emitter<OrchestratorState> emit) {
    if (state is! _Failure) return;
    final current = state as _Failure;
    add(OrchestratorEvent.started(current.role));
  }
}
```

---

## 5. OrchestratorWidget (`orchestrator_widget.dart`)

Es el **puente** entre el OrchestratorBloc y los feature BLoCs. Es el unico lugar del proyecto donde todos los BLoCs se conocen entre si.

### Responsabilidades
1. En `initState` → despacha `OrchestratorEvent.started(role)` via `addPostFrameCallback`.
2. Listener del OrchestratorBloc → cuando el estado es `running`, dispara `load()` al feature BLoC de turno via switch exhaustivo sobre `currentTask`.
3. Listener del OrchestratorBloc → cuando el estado es `success`, navega al home con `pushReplacement`.
4. Listeners de cada feature BLoC → cuando terminan (`loaded`/`error`), notifican al OrchestratorBloc con `taskCompleted` o `taskFailed`.
5. `BlocBuilder` del OrchestratorBloc → muestra la UI de carga, progreso o error.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ... imports de feature BLoCs y screens

class OrchestratorWidget extends StatefulWidget {
  final UserRole role;
  const OrchestratorWidget({super.key, required this.role});

  @override
  State<OrchestratorWidget> createState() => _OrchestratorWidgetState();
}

class _OrchestratorWidgetState extends State<OrchestratorWidget> {
  @override
  void initState() {
    super.initState();
    // CRITICO: usar addPostFrameCallback para garantizar que el arbol
    // de BlocProviders este montado antes de despachar el primer evento.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrchestratorBloc>().add(
          OrchestratorEvent.started(widget.role),
        );
      }
    });
  }

  void _navigateToHome(UserRole role) {
    if (!mounted) return;
    switch (role) {
      case UserRole.gestor:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GestorHome()),
        );
      case UserRole.supervisor:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SupervisorHome()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [

        // ── 1. ORQUESTADOR: dispara el feature BLoC de la tarea activa ──────
        BlocListener<OrchestratorBloc, OrchestratorState>(
          listener: (context, state) {
            state.whenOrNull(
              // NOTA Freezed 3.x: los parametros no usados del running se
              // expresan con underscores simples repetidos (Dart 3 wildcards).
              // NO usar __, ___, ____ (lint unnecessary_underscores).
              running: (currentTask, _, _, _, _) {
                switch (currentTask) {
                  case OrchestratorTask.loadAsignations:
                    context.read<AsignationsBloc>().add(
                      const AsignationsEvent.load(),
                    );
                  case OrchestratorTask.loadCatalogGestor:
                    context.read<CatalogGestorBloc>().add(
                      const CatalogGestorEvent.load(),
                    );
                  case OrchestratorTask.loadPermissions:
                    context.read<PermissionsBloc>().add(
                      const PermissionsEvent.load(),
                    );
                  case OrchestratorTask.loadGestors:
                    context.read<GestorsBloc>().add(const GestorsEvent.load());
                  case OrchestratorTask.loadCatalogSupervisor:
                    context.read<CatalogsSupervisorBloc>().add(
                      const CatalogsSupervisorEvent.load(),
                    );
                }
              },
              success: (role) => _navigateToHome(role),
            );
          },
        ),

        // ── 2. FEATURE BLoCs: reportan al orquestador cuando terminan ───────
        BlocListener<AsignationsBloc, AsignationsState>(
          listener: (context, state) {
            state.whenOrNull(
              loaded: () => context.read<OrchestratorBloc>().add(
                const OrchestratorEvent.taskCompleted(),
              ),
              error: (message) => context.read<OrchestratorBloc>().add(
                OrchestratorEvent.taskFailed(message),
              ),
            );
          },
        ),

        // Repetir el patron anterior para cada feature BLoC adicional...

      ],

      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: BlocBuilder<OrchestratorBloc, OrchestratorState>(
          builder: (context, state) {
            return state.when(
              initial:  () => const _LoadingInitial(),
              running:  (currentTask, _, completedCount, totalCount, role) =>
                  _LoadingRunning(
                    currentTask: currentTask,
                    completedCount: completedCount,
                    totalCount: totalCount,
                    role: role,
                  ),
              success:  (_) => const _LoadingSuccess(),
              failure:  (failedTask, error, _) =>
                  _LoadingFailure(failedTask: failedTask, error: error),
            );
          },
        ),
      ),
    );
  }
}
```

---

## 6. Estructura Obligatoria de los Feature BLoCs

Para que el OrchestratorWidget pueda escucharlos, cada feature BLoC **debe** exponer al menos estos estados Freezed:

```dart
@freezed
sealed class MiFeatureState with _$MiFeatureState {
  const factory MiFeatureState.initial()             = _Initial;
  const factory MiFeatureState.loading()             = _Loading;
  const factory MiFeatureState.loaded()              = _Loaded;   // ← taskCompleted
  const factory MiFeatureState.error(String message) = _Error;    // ← taskFailed
}
```

Y el evento de disparo estandar:

```dart
@freezed
sealed class MiFeatureEvent with _$MiFeatureEvent {
  const factory MiFeatureEvent.load() = _Load;
}
```

### Logs visuales con recuadros (convencion del proyecto)

```dart
Future<void> _onLoad(_Load event, Emitter<MiFeatureState> emit) async {
  emit(const MiFeatureState.loading());
  // ignore: avoid_print
  print('\n╔══════════════════════════════════════════════╗');
  // ignore: avoid_print
  print('║  🟡  [MiFeatureBloc]  CARGANDO...            ║');
  // ignore: avoid_print
  print('╚══════════════════════════════════════════════╝\n');

  await Future.delayed(const Duration(seconds: 2)); // reemplazar con llamada real

  // ignore: avoid_print
  print('\n╔══════════════════════════════════════════════╗');
  // ignore: avoid_print
  print('║  ✅  [MiFeatureBloc]  COMPLETADO             ║');
  // ignore: avoid_print
  print('╚══════════════════════════════════════════════╝\n');

  emit(const MiFeatureState.loaded());
}
```

---

## 7. Provision Global en `main.dart`

Todos los BLoCs — orquestador y features — se proveen globalmente en el `MultiBlocProvider` raiz. Esto es lo que permite al `OrchestratorWidget` acceder a cualquier feature BLoC via `context.read<>()` sin importar su posicion en el arbol.

```dart
void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrchestratorBloc>(create: (_) => OrchestratorBloc()),

        // Feature BLoCs: Gestor
        BlocProvider<AsignationsBloc>(create: (_) => AsignationsBloc()),
        BlocProvider<CatalogGestorBloc>(create: (_) => CatalogGestorBloc()),
        BlocProvider<PermissionsBloc>(create: (_) => PermissionsBloc()),

        // Feature BLoCs: Supervisor
        BlocProvider<GestorsBloc>(create: (_) => GestorsBloc()),
        BlocProvider<CatalogsSupervisorBloc>(create: (_) => CatalogsSupervisorBloc()),
      ],
      child: MaterialApp(
        home: const LoginScreen(),
      ),
    );
  }
}
```

---

## 8. Login: como delegar al orquestador

El login no sabe nada del estado de los BLoCs. Solo navega al `OrchestratorWidget` pasandole el rol elegido.

```dart
void _loginAs(BuildContext context, UserRole role) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => OrchestratorWidget(role: role)),
  );
}
```

---

## 9. Como Extender el Sistema

### Agregar un nuevo rol (ej: `admin`)

1. **`orchestrator_config.dart`**: añadir `admin` a `UserRole` y su lista en `roleTasksConfig`.
2. **`orchestrator_widget.dart`**: añadir `case UserRole.admin:` en `_navigateToHome`.
3. Crear `AdminHome` screen.
4. Eso es todo. El OrchestratorBloc no necesita cambios.

### Agregar una nueva tarea (ej: `loadNotifications`)

1. **`orchestrator_config.dart`**: añadir `loadNotifications(isCritical: false, label: 'Notificaciones')` al enum y a la lista del rol correspondiente.
2. **`orchestrator_widget.dart`**: añadir el `case OrchestratorTask.loadNotifications:` en el switch del listener del OrchestratorBloc, y añadir el `BlocListener<NotificationsBloc, NotificationsState>` en la lista de listeners.
3. **`main.dart`**: añadir `BlocProvider<NotificationsBloc>`.
4. Crear el feature BLoC con estados `initial / loading / loaded / error`.

---

## 10. Gotchas y Detalles Tecnicos Criticos

### Freezed 3.x — `when` / `whenOrNull` son extension methods
En Freezed 3.x los metodos `when` y `whenOrNull` se generan como **extension methods** sobre la clase sealed, no como metodos de instancia. Se usan igual (`state.whenOrNull(...)`), pero si el archivo `.freezed.dart` no existe aun, el linter reportara errores. Ejecutar `build_runner` los resuelve.

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Wildcards en `whenOrNull` (Dart 3)
Al usar `whenOrNull` en el listener del OrchestratorBloc, los parametros no usados del callback `running` deben escribirse con **underscores simples repetidos**:

```dart
// CORRECTO (Dart 3 wildcards — lint: OK)
running: (currentTask, _, _, _, _) { ... }

// INCORRECTO (lint: unnecessary_underscores)
running: (currentTask, _, __, ___, ____) { ... }
```

### `withOpacity` deprecado → usar `withValues`
```dart
// INCORRECTO (deprecated en Flutter actual)
color.withOpacity(0.5)

// CORRECTO
color.withValues(alpha: 0.5)
```

### `bloc` debe ser dependencia directa
Aunque `flutter_bloc` incluye `bloc` transitivamente, el lint `depend_on_referenced_packages` exige declararlo explicitamente en `pubspec.yaml` si se importa directamente en el codigo.

```yaml
dependencies:
  bloc: ^9.0.0           # dependencia directa requerida
  flutter_bloc: ^9.1.1
  freezed_annotation: ^3.1.0

dev_dependencies:
  freezed: ^3.2.5
  build_runner: ^2.14.0
```

### `addPostFrameCallback` en `initState`
El evento `started` **no** puede despacharse directamente en `initState` porque el arbol de widgets (y los `BlocProvider`) aun no estan completamente montados. Usar siempre:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      context.read<OrchestratorBloc>().add(
        OrchestratorEvent.started(widget.role),
      );
    }
  });
}
```

### Widgets privados en HomeScreens separados
Si `GestorHome` y `SupervisorHome` estan en archivos distintos, los widgets con prefijo `_` (privados) como `_WelcomeBanner` y `_ModuleCard` **no se comparten** entre archivos. Deben duplicarse o extraerse a un archivo compartido.

### Navegacion de logout
El logout usa `Navigator.of(context).pop()` desde el HomeScreen. Esto funciona porque el flujo de push fue:

```
LoginScreen → push → OrchestratorWidget → pushReplacement → HomeScreen
```

El `pushReplacement` elimina el `OrchestratorWidget` del stack, por lo que el `pop` desde el HomeScreen regresa directamente al `LoginScreen`. Al regresar, el `OrchestratorBloc` **no se resetea automaticamente** porque fue provisto globalmente; si se necesita un estado limpio al volver a login, se debe despachar `OrchestratorEvent` de reset o usar `BlocProvider` local en el `OrchestratorWidget`.

---

## 11. Reglas de Verificacion para el Auditor

1. **Switch exhaustivo**: El switch sobre `OrchestratorTask` en el `OrchestratorWidget` debe cubrir **todos** los valores del enum. El compilador de Dart lo garantiza si el switch no tiene `default`.
2. **Un solo listener por feature BLoC**: Cada feature BLoC debe tener exactamente un `BlocListener` en el `OrchestratorWidget`. Duplicados generan dobles notificaciones.
3. **Estado inicial limpio**: Cada feature BLoC debe iniciar en `initial()`, no en `loading()`. El orquestador es quien autoriza el inicio de cada carga.
4. **No acoplar HomeScreens al OrchestratorBloc**: Los HomeScreens no deben leer ni escuchar al `OrchestratorBloc`. Su unico rol es mostrar el contenido ya cargado.
5. **isCritical declarado en config, no en BLoC**: La decision de si una tarea es critica es responsabilidad exclusiva de `orchestrator_config.dart`, nunca del feature BLoC.
6. **Retry siempre desde cero**: El handler `_onRetry` debe re-despachar `started` con el rol completo, nunca intentar reanudar desde `pendingTasks` del estado anterior.
