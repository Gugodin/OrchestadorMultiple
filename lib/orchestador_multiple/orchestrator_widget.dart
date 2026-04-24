import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../depending_blocs/gestor/asignations_bloc/asignations_bloc.dart';
import '../depending_blocs/gestor/catalog_gestor_bloc/catalog_gestor_bloc.dart';
import '../depending_blocs/gestor/permissions_bloc/permissions_bloc.dart';
import '../depending_blocs/supervisor/catalog_supervisor_bloc/catalogs_supervisor_bloc.dart';
import '../depending_blocs/supervisor/gestors_bloc/gestors_bloc.dart';
import '../screens/gestor_home.dart';
import '../screens/supervisor_home.dart';
import 'bloc/orchestrator_bloc.dart';
import 'orchestrator_config.dart';

/// ============================================================
/// ORCHESTRATOR WIDGET
/// ============================================================
/// Puente de comunicación entre el [OrchestratorBloc] y los
/// feature BLoCs. Es el único lugar del proyecto donde los
/// BLoCs "se conocen" entre sí.
///
/// Responsabilidades:
///   - Escucha al [OrchestratorBloc]: cuando emite una tarea
///     en estado [running], dispara el evento `load()` al
///     feature BLoC correspondiente.
///   - Escucha cada feature BLoC: cuando terminan (loaded/error),
///     notifica al [OrchestratorBloc] con [taskCompleted] o [taskFailed].
///   - Navega al Home del rol correspondiente al recibir [success].
///   - Muestra la pantalla de error con botón de reintento al recibir [failure].
///
/// Para AGREGAR UNA NUEVA TAREA:
///   1. Agrega el case en el switch del listener del [OrchestratorBloc].
///   2. Agrega el BlocListener del nuevo feature BLoC.
/// ============================================================
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
    // Disparamos el evento después del primer frame para garantizar
    // que el árbol de widgets (y los BlocProviders) estén montados.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrchestratorBloc>().add(
          OrchestratorEvent.started(widget.role),
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Navegación
  // ─────────────────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ── 1. ORQUESTADOR ──────────────────────────────────────────────────
        // Cuando el orquestador emite una tarea activa, disparamos el
        // evento `load()` del feature BLoC correspondiente.
        // El switch es exhaustivo: el compilador avisará si falta un case.
        BlocListener<OrchestratorBloc, OrchestratorState>(
          listener: (context, state) {
            state.whenOrNull(
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

        // ── 2. FEATURE BLoCs ─────────────────────────────────────────────────
        // Cada feature BLoC reporta al orquestador cuando termina o falla.
        // El orquestador decide si avanzar o detenerse según la criticidad.
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

        BlocListener<CatalogGestorBloc, CatalogGestorState>(
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

        BlocListener<PermissionsBloc, PermissionsState>(
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

        BlocListener<GestorsBloc, GestorsState>(
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

        BlocListener<CatalogsSupervisorBloc, CatalogsSupervisorState>(
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
      ],

      // ── UI ────────────────────────────────────────────────────────────────
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: BlocBuilder<OrchestratorBloc, OrchestratorState>(
          builder: (context, state) {
            return state.when(
              initial: () => const _LoadingInitial(),
              running: (currentTask, _, completedCount, totalCount, role) =>
                  _LoadingRunning(
                    currentTask: currentTask,
                    completedCount: completedCount,
                    totalCount: totalCount,
                    role: role,
                  ),
              success: (_) => const _LoadingSuccess(),
              failure: (failedTask, error, _) =>
                  _LoadingFailure(failedTask: failedTask, error: error),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets de UI del Orquestador
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingInitial extends StatelessWidget {
  const _LoadingInitial();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white54),
    );
  }
}

class _LoadingRunning extends StatelessWidget {
  final OrchestratorTask currentTask;
  final int completedCount;
  final int totalCount;
  final UserRole role;

  const _LoadingRunning({
    required this.currentTask,
    required this.completedCount,
    required this.totalCount,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono animado
            const Icon(
              Icons.settings_suggest_rounded,
              color: Colors.blueAccent,
              size: 72,
            ),
            const SizedBox(height: 32),

            // Etiqueta del rol
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _roleLabel(role).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nombre de la tarea actual
            Text(
              'Cargando ${currentTask.label}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Indicador de criticidad
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  currentTask.isCritical
                      ? Icons.lock_outline
                      : Icons.lock_open_outlined,
                  size: 14,
                  color: currentTask.isCritical
                      ? Colors.orangeAccent
                      : Colors.greenAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  currentTask.isCritical ? 'Módulo crítico' : 'Módulo opcional',
                  style: TextStyle(
                    color: currentTask.isCritical
                        ? Colors.orangeAccent
                        : Colors.greenAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Contador de pasos
            Text(
              'Paso $completedCount de $totalCount',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(UserRole role) => switch (role) {
    UserRole.gestor => 'Gestor',
    UserRole.supervisor => 'Supervisor',
  };
}

class _LoadingSuccess extends StatelessWidget {
  const _LoadingSuccess();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.greenAccent),
    );
  }
}

class _LoadingFailure extends StatelessWidget {
  final OrchestratorTask failedTask;
  final String error;

  const _LoadingFailure({required this.failedTask, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 72,
            ),
            const SizedBox(height: 24),
            const Text(
              'Error crítico',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No se pudo cargar el módulo "${failedTask.label}".',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
              ),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.read<OrchestratorBloc>().add(
                const OrchestratorEvent.retry(),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar desde el inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
