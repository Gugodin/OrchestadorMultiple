// ============================================================
// ORCHESTRATOR CONFIG
// ============================================================
// Archivo central del sistema de orquestación.
//
// Para AGREGAR UN NUEVO ROL:
//   1. Añade el valor en [UserRole]
//   2. Define sus tareas en [roleTasksConfig]
//
// Para AGREGAR UNA NUEVA TAREA:
//   1. Añade el valor en [OrchestratorTask] con su [isCritical] y [label]
//   2. Agrégala a la lista del rol correspondiente en [roleTasksConfig]
//   3. Agrega el case en el switch del OrchestratorWidget
// ============================================================

/// Roles disponibles en la aplicación.
enum UserRole { gestor, supervisor }

/// Tareas que el orquestador puede ejecutar.
///
/// [isCritical]: si es `true`, un fallo en esta tarea detiene por
///               completo la orquestación y muestra la pantalla de error.
///               Si es `false`, la tarea se omite y la orquestación continúa.
/// [label]:      nombre legible para mostrar en la UI durante la carga.
enum OrchestratorTask {
  loadAsignations(isCritical: true, label: 'Asignaciones'),
  loadCatalogGestor(isCritical: true, label: 'Catálogo Gestor'),
  loadPermissions(isCritical: false, label: 'Permisos'),
  loadGestors(isCritical: true, label: 'Gestores'),
  loadCatalogSupervisor(isCritical: true, label: 'Catálogo Supervisor');

  final bool isCritical;
  final String label;
  const OrchestratorTask({required this.isCritical, required this.label});
}

/// Mapa de configuración: qué tareas debe cargar cada rol al iniciar sesión.
///
/// El orden en la lista define la secuencia de carga (secuencial, de arriba hacia abajo).
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
