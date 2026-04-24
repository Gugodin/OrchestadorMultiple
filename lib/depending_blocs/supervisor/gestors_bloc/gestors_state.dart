part of 'gestors_bloc.dart';

@freezed
class GestorsState with _$GestorsState {
  const factory GestorsState.initial() = _Initial;
  const factory GestorsState.loading() = _Loading;
  const factory GestorsState.loaded() = _Loaded;
  const factory GestorsState.error(String message) = _Error;
}
