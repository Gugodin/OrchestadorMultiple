part of 'orchestrator_bloc.dart';

@freezed
sealed class OrchestratorEvent with _$OrchestratorEvent {
  /// Inicia la orquestación cargando la cola de tareas del [role] dado.
  const factory OrchestratorEvent.started(UserRole role) = _Started;

  /// Notifica al orquestador que la tarea actual se completó exitosamente.
  /// El orquestador avanzará automáticamente a la siguiente tarea de la cola.
  const factory OrchestratorEvent.taskCompleted() = _TaskCompleted;

  /// Notifica al orquestador que la tarea actual falló con un [error].
  /// Si la tarea es crítica, la orquestación se detiene.
  /// Si no es crítica, se omite y se continúa con la siguiente.
  const factory OrchestratorEvent.taskFailed(String error) = _TaskFailed;

  /// Reinicia la orquestación desde cero.
  /// Solo tiene efecto si el estado actual es [OrchestratorState.failure].
  const factory OrchestratorEvent.retry() = _Retry;
}
