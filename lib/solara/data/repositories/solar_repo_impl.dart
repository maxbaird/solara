import '../../../core/resources/solara_io_exception.dart';
import '../../domain/entities/solar.dart';
import '../../domain/repositories/solar_repo.dart';
import '../models/solar_model.dart';

class SolarRepoImpl extends SolarRepo {
  const SolarRepoImpl(
    super.solarRemoteDataSource,
    super.solarLocalDataSource,
  );

  @override
  Future<(List<SolarEntity>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    // Try fetching local first
    var (solarEntities, err) = await fetchLocal(date: date);

    // If error or no local data then fetch remote
    if (solarEntities == null || solarEntities.isEmpty) {
      (solarEntities, err) = await fetchRemote(date: date);

      if (solarEntities != null && solarEntities.isNotEmpty) {
        // Cache results
        for (var solarEntity in solarEntities) {
          createLocal(solarEntity);
        }
      }
    }

    return (solarEntities, err);
  }

  @override
  Future<(List<SolarEntity>?, SolaraIOException?)> fetchRemote(
      {DateTime? date}) async {
    var (solarEntities, err) = await solarRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(solarEntities), err);
  }

  @override
  Future<(List<SolarEntity>?, SolaraIOException?)> fetchLocal(
      {DateTime? date}) async {
    var (solarModels, err) = await solarLocalDataSource.fetch(date: date);
    return (_toEntityList(solarModels), err);
  }

  @override
  Future<bool> createLocal(SolarEntity solar) {
    return solarLocalDataSource.create(SolarModel.fromEntity(solar));
  }

  @override
  Future<void> clearStorage() {
    return solarLocalDataSource.clear();
  }

  List<SolarEntity> _toEntityList(List<SolarModel>? models) {
    List<SolarEntity> entities = [];

    if (models == null) {
      return entities;
    }

    for (var model in models) {
      entities.add(model.toEntity());
    }

    return entities;
  }
}
