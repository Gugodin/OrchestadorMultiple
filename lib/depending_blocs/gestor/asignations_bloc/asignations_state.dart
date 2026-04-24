part of 'asignations_bloc.dart';

@freezed
class AsignationsState with _$AsignationsState {
  const factory AsignationsState.initial() = _Initial;
  const factory AsignationsState.loading() = _Loading;
  const factory AsignationsState.loaded() = _Loaded;
  const factory AsignationsState.error(String message) = _Error;
}
