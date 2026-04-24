import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gestors_event.dart';
part 'gestors_state.dart';
part 'gestors_bloc.freezed.dart';

class GestorsBloc extends Bloc<GestorsEvent, GestorsState> {
  GestorsBloc() : super(const GestorsState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<GestorsState> emit) async {
    emit(const GestorsState.loading());
    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🟡  [GestorsBloc]  CARGANDO...              ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');

    await Future.delayed(const Duration(seconds: 2));

    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  ✅  [GestorsBloc]  COMPLETADO               ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');
    emit(const GestorsState.loaded());
  }
}
