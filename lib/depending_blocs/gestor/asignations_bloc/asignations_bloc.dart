import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asignations_event.dart';
part 'asignations_state.dart';
part 'asignations_bloc.freezed.dart';

class AsignationsBloc extends Bloc<AsignationsEvent, AsignationsState> {
  AsignationsBloc() : super(const AsignationsState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<AsignationsState> emit) async {
    emit(const AsignationsState.loading());
    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🟡  [AsignationsBloc]  CARGANDO...          ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');

    await Future.delayed(const Duration(seconds: 2));

    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  ✅  [AsignationsBloc]  COMPLETADO           ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');
    emit(const AsignationsState.loaded());

    // // ignore: avoid_print
    // print('\n╔══════════════════════════════════════════════╗');
    // // ignore: avoid_print
    // print('║  ❌  [AsignationsBloc]  ERROR                ║');
    // // ignore: avoid_print
    // print('╚══════════════════════════════════════════════╝\n');
    // emit(const AsignationsState.error('Error al cargar asignaciones'));
  }
}
