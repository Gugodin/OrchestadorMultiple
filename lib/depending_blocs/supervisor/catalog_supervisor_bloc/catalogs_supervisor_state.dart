part of 'catalogs_supervisor_bloc.dart';

@freezed
class CatalogsSupervisorState with _$CatalogsSupervisorState {
  const factory CatalogsSupervisorState.initial() = _Initial;
  const factory CatalogsSupervisorState.loading() = _Loading;
  const factory CatalogsSupervisorState.loaded() = _Loaded;
  const factory CatalogsSupervisorState.error(String message) = _Error;
}
