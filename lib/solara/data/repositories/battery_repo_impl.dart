import '../../../core/resources/solara_io_exception.dart';
import '../../domain/entities/battery.dart';
import '../../domain/repositories/battery_repo.dart';
import '../models/battery_model.dart';

/// This class is a concrete implementation for [BatteryRepo].
///
/// [BatteryRepoImpl] provides implementations for the abstract operations
/// defined in [BatteryRepo]. [BatteryRepo] is defined abstractly in the domain
/// layer of the application and its implementation resides here in the data
/// layer. The idea that data repositories should plug in to the domain layer.
///
/// This way, the concrete implementation of where/how the data is retrieved
/// will not affect the rest of the application as long as it adheres to the
/// [BatteryRepo] interface.
class BatteryRepoImpl extends BatteryRepo {
  const BatteryRepoImpl(
    super.batteryRemoteDataSource,
    super.batteryLocalDataSource,
  );

  @override
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
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
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchRemote(
      {DateTime? date}) async {
    var (batteryModels, err) = await batteryRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(batteryModels), err);
  }

  @override
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchLocal(
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

  /// Converts a list of models to a list of entities.
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
