import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalogs_supervisor_event.dart';
part 'catalogs_supervisor_state.dart';
part 'catalogs_supervisor_bloc.freezed.dart';

class CatalogsSupervisorBloc
    extends Bloc<CatalogsSupervisorEvent, CatalogsSupervisorState> {
  CatalogsSupervisorBloc() : super(const CatalogsSupervisorState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(
    _Load event,
    Emitter<CatalogsSupervisorState> emit,
  ) async {
    emit(const CatalogsSupervisorState.loading());
    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🟡  [CatalogsSupervisorBloc]  CARGANDO...   ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');

    await Future.delayed(const Duration(seconds: 2));

    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  ✅  [CatalogsSupervisorBloc]  COMPLETADO    ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');
    emit(const CatalogsSupervisorState.loaded());
  }
}
