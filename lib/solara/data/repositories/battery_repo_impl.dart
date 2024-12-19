import '../datasources/battery_remote_datasource.dart';
import '../../../core/resources/http_error.dart';
import '../../domain/entities/battery.dart';
import '../../domain/repositories/battery_repo.dart';
import '../models/battery_model.dart';

class BatteryRepoImpl implements BatteryRepo {
  const BatteryRepoImpl(this.batteryRemoteDataSource);
  final BatteryRemoteDataSource batteryRemoteDataSource;

  @override
  Future<(List<BatteryEntity>?, HttpError?)> fetch({DateTime? date}) async {
    var (batteryEntities, err) = await batteryRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(batteryEntities), err);
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
