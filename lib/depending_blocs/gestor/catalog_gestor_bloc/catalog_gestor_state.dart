part of 'catalog_gestor_bloc.dart';

@freezed
class CatalogGestorState with _$CatalogGestorState {
  const factory CatalogGestorState.initial() = _Initial;
  const factory CatalogGestorState.loading() = _Loading;
  const factory CatalogGestorState.loaded() = _Loaded;
  const factory CatalogGestorState.error(String message) = _Error;
}
