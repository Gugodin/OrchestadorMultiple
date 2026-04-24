import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';
part 'permissions_bloc.freezed.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(const PermissionsState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<PermissionsState> emit) async {
    emit(const PermissionsState.loading());
    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🟡  [PermissionsBloc]  CARGANDO...          ║');
    // ignore: avoid_print
    print('║  ⚠️   (Módulo opcional - no es crítico)       ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');

    await Future.delayed(const Duration(seconds: 2));

    // ignore: avoid_print
    print('\n╔══════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  ✅  [PermissionsBloc]  COMPLETADO           ║');
    // ignore: avoid_print
    print('╚══════════════════════════════════════════════╝\n');
    emit(const PermissionsState.loaded());
  }
}
