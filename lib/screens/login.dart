import 'package:flutter/material.dart';

import '../orchestador_multiple/orchestrator_config.dart';
import '../orchestador_multiple/orchestrator_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _loginAs(BuildContext context, UserRole role) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => OrchestratorWidget(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              const Icon(
                Icons.account_tree_rounded,
                size: 48,
                color: Color(0xFF1A1A2E),
              ),
              const SizedBox(height: 16),
              const Text(
                'Orquestador',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'Selecciona tu rol para iniciar sesión',
                style: TextStyle(fontSize: 16, color: Colors.black45),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 32),

              // ── Tarjeta: Gestor ──────────────────────────────────────────
              _RoleCard(
                title: 'Gestor',
                subtitle: 'Gestión de asignaciones, catálogos y permisos',
                icon: Icons.manage_accounts_rounded,
                color: const Color(0xFF1565C0),
                tasks: roleTasksConfig[UserRole.gestor]!,
                onTap: () => _loginAs(context, UserRole.gestor),
              ),
              const SizedBox(height: 20),

              // ── Tarjeta: Supervisor ──────────────────────────────────────
              _RoleCard(
                title: 'Supervisor',
                subtitle: 'Supervisión de gestores y catálogos del equipo',
                icon: Icons.supervisor_account_rounded,
                color: const Color(0xFF2E7D32),
                tasks: roleTasksConfig[UserRole.supervisor]!,
                onTap: () => _loginAs(context, UserRole.supervisor),
              ),
              const SizedBox(height: 40),

              // ── Nota informativa ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cada rol carga únicamente los módulos que necesita.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta de Rol
// ─────────────────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<OrchestratorTask> tasks;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tasks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Encabezado ───────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color.withValues(alpha: 0.5),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // ── Lista de módulos ─────────────────────────────────────────
              Text(
                'Módulos que se cargarán:',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        task.isCritical
                            ? Icons.lock_outline_rounded
                            : Icons.lock_open_outlined,
                        size: 14,
                        color: task.isCritical
                            ? Colors.orangeAccent
                            : Colors.greenAccent.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        task.label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.isCritical ? '(crítico)' : '(opcional)',
                        style: TextStyle(
                          fontSize: 11,
                          color: task.isCritical
                              ? Colors.orangeAccent
                              : Colors.greenAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
