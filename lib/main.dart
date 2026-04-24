import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Orquestador
import 'orchestador_multiple/bloc/orchestrator_bloc.dart';

// Feature BLoCs — Gestor
import 'depending_blocs/gestor/asignations_bloc/asignations_bloc.dart';
import 'depending_blocs/gestor/catalog_gestor_bloc/catalog_gestor_bloc.dart';
import 'depending_blocs/gestor/permissions_bloc/permissions_bloc.dart';

// Feature BLoCs — Supervisor
import 'depending_blocs/supervisor/catalog_supervisor_bloc/catalogs_supervisor_bloc.dart';
import 'depending_blocs/supervisor/gestors_bloc/gestors_bloc.dart';

// Pantallas
import 'screens/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ── Orquestador ──────────────────────────────────────────────────
        BlocProvider<OrchestratorBloc>(create: (_) => OrchestratorBloc()),

        // ── Feature BLoCs: Gestor ────────────────────────────────────────
        BlocProvider<AsignationsBloc>(create: (_) => AsignationsBloc()),
        BlocProvider<CatalogGestorBloc>(create: (_) => CatalogGestorBloc()),
        BlocProvider<PermissionsBloc>(create: (_) => PermissionsBloc()),

        // ── Feature BLoCs: Supervisor ────────────────────────────────────
        BlocProvider<GestorsBloc>(create: (_) => GestorsBloc()),
        BlocProvider<CatalogsSupervisorBloc>(
          create: (_) => CatalogsSupervisorBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Orquestador de Roles',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1A1A2E),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
