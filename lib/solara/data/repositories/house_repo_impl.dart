import '../../../core/resources/solara_io_error.dart';
import '../../domain/entities/house.dart';
import '../../domain/repositories/house_repo.dart';
import '../models/house_model.dart';

class HouseRepoImpl extends HouseRepo {
  const HouseRepoImpl(
    super.houseRemoteDataSource,
    super.houseLocalDataSource,
  );

  @override
  Future<(List<HouseEntity>?, SolaraIOError?)> fetch({DateTime? date}) async {
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
  Future<(List<HouseEntity>?, SolaraIOError?)> fetchRemote(
      {DateTime? date}) async {
    var (houseEntities, err) = await houseRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(houseEntities), err);
  }

  @override
  Future<(List<HouseEntity>?, SolaraIOError?)> fetchLocal(
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
