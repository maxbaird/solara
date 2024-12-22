import '../../../core/resources/solara_io_exception.dart';
import '../../domain/entities/house.dart';
import '../../domain/repositories/house_repo.dart';
import '../models/house_model.dart';

/// This class is a concrete implementation for [HouseRepo].
///
/// [HouseRepoImpl] provides implementations for the abstract operations
/// defined in [HouseRepo]. [HouseRepo] is defined abstractly in the domain
/// layer of the application and its implementation resides here in the data
/// layer. The idea that data repositories should plug in to the domain layer.
///
/// This way, the concrete implementation of where/how the data is retrieved
/// will not affect the rest of the application as long as it adheres to the
/// [HouseRepo] interface.
class HouseRepoImpl extends HouseRepo {
  const HouseRepoImpl(
    super.houseRemoteDataSource,
    super.houseLocalDataSource,
  );

  @override
  Future<(List<HouseEntity>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    // Try fetching local first
    var (houseEntities, err) = await fetchLocal(date: date);

    // If error or no local data then fetch remote
    if (houseEntities == null || houseEntities.isEmpty) {
      (houseEntities, err) = await fetchRemote(date: date);

      if (houseEntities != null && houseEntities.isNotEmpty) {
        // Cache results
        for (var houseEntity in houseEntities) {
          createLocal(houseEntity);
        }
      }
    }

    return (houseEntities, err);
  }

  @override
  Future<(List<HouseEntity>?, SolaraIOException?)> fetchRemote(
      {DateTime? date}) async {
    var (houseModels, err) = await houseRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(houseModels), err);
  }

  @override
  Future<(List<HouseEntity>?, SolaraIOException?)> fetchLocal(
      {DateTime? date}) async {
    var (houseModels, err) = await houseLocalDataSource.fetch(date: date);
    return (_toEntityList(houseModels), err);
  }

  @override
  Future<bool> createLocal(HouseEntity house) {
    return houseLocalDataSource.create(HouseModel.fromEntity(house));
  }

  @override
  Future<void> clearStorage() {
    return houseLocalDataSource.clear();
  }

  /// Converts a list of models to a list of entities.
  List<HouseEntity> _toEntityList(List<HouseModel>? models) {
    List<HouseEntity> entities = [];

    if (models == null) {
      return entities;
    }

    for (var model in models) {
      entities.add(model.toEntity());
    }

    return entities;
  }
}
