part of 'orchestrator_bloc.dart';

@freezed
sealed class OrchestratorState with _$OrchestratorState {
  /// Estado inicial antes de que comience la orquestación.
  const factory OrchestratorState.initial() = _Initial;

  /// La orquestación está en progreso ejecutando [currentTask].
  /// [pendingTasks]:  tareas que aún no han comenzado.
  /// [completedCount]: número de tareas ya finalizadas.
  /// [totalCount]:    número total de tareas para este rol.
  const factory OrchestratorState.running({
    required OrchestratorTask currentTask,
    required List<OrchestratorTask> pendingTasks,
    required int completedCount,
    required int totalCount,
    required UserRole role,
  }) = _Running;

  /// Todas las tareas del rol se completaron exitosamente.
  const factory OrchestratorState.success({required UserRole role}) = _Success;

  /// Una tarea crítica falló y la orquestación se detuvo.
  /// [failedTask]: la tarea que provocó el fallo.
  /// [error]:      mensaje descriptivo del error.
  const factory OrchestratorState.failure({
    required OrchestratorTask failedTask,
    required String error,
    required UserRole role,
  }) = _Failure;
}
