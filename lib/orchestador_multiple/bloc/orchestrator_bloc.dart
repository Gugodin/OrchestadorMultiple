import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../orchestrator_config.dart';

part 'orchestrator_event.dart';
part 'orchestrator_state.dart';
part 'orchestrator_bloc.freezed.dart';

/// Orquestador principal del flujo de inicio de sesión por roles.
///
/// Responsabilidades:
///   - Cargar la cola de tareas configurada para el [UserRole] recibido.
///   - Emitir de forma secuencial cada [OrchestratorTask] para que el
///     [OrchestratorWidget] dispare el BLoC de feature correspondiente.
///   - Avanzar en la cola cuando recibe [OrchestratorEvent.taskCompleted].
///   - Evaluar la criticidad de un fallo: si [OrchestratorTask.isCritical]
///     es true, detiene la orquestación; si es false, omite y continúa.
///   - Reiniciar desde cero al recibir [OrchestratorEvent.retry].
class OrchestratorBloc extends Bloc<OrchestratorEvent, OrchestratorState> {
  OrchestratorBloc() : super(const OrchestratorState.initial()) {
    on<_Started>(_onStarted);
    on<_TaskCompleted>(_onTaskCompleted);
    on<_TaskFailed>(_onTaskFailed);
    on<_Retry>(_onRetry);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Handlers
  // ─────────────────────────────────────────────────────────────────────────

  /// Carga la cola de tareas para el rol y emite la primera.
  void _onStarted(_Started event, Emitter<OrchestratorState> emit) {
    final tasks = List<OrchestratorTask>.from(
      roleTasksConfig[event.role] ?? [],
    );

    if (tasks.isEmpty) {
      emit(OrchestratorState.success(role: event.role));
      return;
    }

    emit(
      OrchestratorState.running(
        currentTask: tasks.first,
        pendingTasks: tasks.sublist(1),
        completedCount: 0,
        totalCount: tasks.length,
        role: event.role,
      ),
    );
  }

  /// Marca la tarea actual como completada y avanza a la siguiente de la cola.
  /// Si no hay más tareas, emite [OrchestratorState.success].
  void _onTaskCompleted(_TaskCompleted event, Emitter<OrchestratorState> emit) {
    if (state is! _Running) return;
    final current = state as _Running;
 
    final newCompleted = current.completedCount + 1;

    if (current.pendingTasks.isEmpty) {
      emit(OrchestratorState.success(role: current.role));
    } else {
      emit(
        OrchestratorState.running(
          currentTask: current.pendingTasks.first,
          pendingTasks: current.pendingTasks.sublist(1),
          completedCount: newCompleted,
          totalCount: current.totalCount,
          role: current.role,
        ),
      );
    }
  }

  /// Evalúa si la tarea fallida es crítica:
  ///   - Crítica → emite [OrchestratorState.failure] y detiene la orquestación.
  ///   - No crítica → omite la tarea y avanza a la siguiente (o éxito si fue la última).
  void _onTaskFailed(_TaskFailed event, Emitter<OrchestratorState> emit) {
    if (state is! _Running) return;
    final current = state as _Running;

    if (current.currentTask.isCritical) {
      emit(
        OrchestratorState.failure(
          failedTask: current.currentTask,
          error: event.error,
          role: current.role,
        ),
      );
      return;
    }

    // Tarea no crítica: se registra el skip y se avanza.
    final newCompleted = current.completedCount + 1;
    if (current.pendingTasks.isEmpty) {
      emit(OrchestratorState.success(role: current.role));
    } else {
      emit(
        OrchestratorState.running(
          currentTask: current.pendingTasks.first,
          pendingTasks: current.pendingTasks.sublist(1),
          completedCount: newCompleted,
          totalCount: current.totalCount,
          role: current.role,
        ),
      );
    }
  }

  /// Reinicia la orquestación desde cero con el rol del estado de fallo.
  void _onRetry(_Retry event, Emitter<OrchestratorState> emit) {
    if (state is! _Failure) return;
    final current = state as _Failure;
    add(OrchestratorEvent.started(current.role));
  }
}
