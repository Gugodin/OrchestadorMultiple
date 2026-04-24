part of 'catalogs_supervisor_bloc.dart';

@freezed
class CatalogsSupervisorEvent with _$CatalogsSupervisorEvent {
  const factory CatalogsSupervisorEvent.load() = _Load;
}
