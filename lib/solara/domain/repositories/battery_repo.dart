import '../../../core/resources/http_error.dart';
import '../../data/datasources/battery_remote_datasource.dart';
import '../entities/battery.dart';

abstract class BatteryRepo {
  const BatteryRepo(this.batteryRemoteDataSource);

  final BatteryRemoteDataSource batteryRemoteDataSource;

  Future<(List<BatteryEntity>?, HttpError?)> fetch({
    DateTime? date,
  });
}
