part of 'permissions_bloc.dart';

@freezed
class PermissionsState with _$PermissionsState {
  const factory PermissionsState.initial() = _Initial;
  const factory PermissionsState.loading() = _Loading;
  const factory PermissionsState.loaded() = _Loaded;
  const factory PermissionsState.error(String message) = _Error;
}
