import '../../../core/resources/solara_io_exception.dart';
import '../../domain/entities/solar.dart';
import '../../domain/repositories/solar_repo.dart';
import '../models/solar_model.dart';

/// This class is a concrete implementation for [SolarRepo].
///
/// [SolarRepoImpl] provides implementations for the abstract operations
/// defined in [SolarRepo]. [SolarRepo] is defined abstractly in the domain
/// layer of the application and its implementation resides here in the data
/// layer. The idea that data repositories should plug in to the domain layer.
///
/// This way, the concrete implementation of where/how the data is retrieved
/// will not affect the rest of the application as long as it adheres to the
/// [SolarRepo] interface.
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
    var (solarModels, err) = await solarRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(solarModels), err);
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

  /// Converts a list of models to a list of entities.
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
