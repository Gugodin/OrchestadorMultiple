import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_gestor_event.dart';
part 'catalog_gestor_state.dart';
part 'catalog_gestor_bloc.freezed.dart';

class CatalogGestorBloc extends Bloc<CatalogGestorEvent, CatalogGestorState> {
  CatalogGestorBloc() : super(const CatalogGestorState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<CatalogGestorState> emit) async {
    emit(const CatalogGestorState.loading());
    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🟡  [CatalogGestorBloc]  CARGANDO...        ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');

    await Future.delayed(const Duration(seconds: 2));

    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  ✅  [CatalogGestorBloc]  COMPLETADO         ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');
    emit(const CatalogGestorState.loaded());
  }
}
