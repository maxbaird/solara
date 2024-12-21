import '../../../core/resources/solara_io_error.dart';
import '../../domain/entities/battery.dart';
import '../../domain/repositories/battery_repo.dart';
import '../models/battery_model.dart';

class BatteryRepoImpl extends BatteryRepo {
  const BatteryRepoImpl(
    super.batteryRemoteDataSource,
    super.batteryLocalDataSource,
  );

  @override
  Future<(List<BatteryEntity>?, SolaraIOError?)> fetch({DateTime? date}) async {
    // Try fetching local first
    var (batteryEntities, err) = await fetchLocal(date: date);

    // If error or no local data then fetch remote
    if (batteryEntities == null || batteryEntities.isEmpty) {
      (batteryEntities, err) = await fetchRemote(date: date);

      if (batteryEntities != null && batteryEntities.isNotEmpty) {
        // Cache results
        for (var batteryEntity in batteryEntities) {
          createLocal(batteryEntity);
        }
      }
    }

    return (batteryEntities, err);
  }

  @override
  Future<(List<BatteryEntity>?, SolaraIOError?)> fetchRemote(
      {DateTime? date}) async {
    var (batteryEntities, err) = await batteryRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(batteryEntities), err);
  }

  @override
  Future<(List<BatteryEntity>?, SolaraIOError?)> fetchLocal(
      {DateTime? date}) async {
    var (batteryModels, err) = await batteryLocalDataSource.fetch(date: date);
    return (_toEntityList(batteryModels), err);
  }

  @override
  Future<bool> createLocal(BatteryEntity battery) {
    return batteryLocalDataSource.create(BatteryModel.fromEntity(battery));
  }

  @override
  Future<void> clearStorage() {
    return batteryLocalDataSource.clear();
  }

  List<BatteryEntity> _toEntityList(List<BatteryModel>? models) {
    List<BatteryEntity> entities = [];

    if (models == null) {
      return entities;
    }

    for (var model in models) {
      entities.add(model.toEntity());
    }

    return entities;
  }
}
