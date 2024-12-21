import '../../../core/resources/solara_io_exception.dart';
import '../../data/datasources/battery_local_datasource.dart';
import '../../data/datasources/battery_remote_datasource.dart';
import '../entities/battery.dart';

abstract class BatteryRepo {
  const BatteryRepo(
    this.batteryRemoteDataSource,
    this.batteryLocalDataSource,
  );

  final BatteryRemoteDataSource batteryRemoteDataSource;
  final BatteryLocalDataSource batteryLocalDataSource;

  Future<(List<BatteryEntity>?, SolaraIOException?)> fetch({
    DateTime? date,
  });

  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchRemote({
    DateTime? date,
  });

  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchLocal({
    DateTime? date,
  });

  Future<bool> createLocal(BatteryEntity battery);

  Future<void> clearStorage();
}
