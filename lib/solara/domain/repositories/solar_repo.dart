import '../../../core/resources/http_error.dart';
import '../../data/datasources/solar_local_datasource.dart';
import '../../data/datasources/solar_remote_datasource.dart';
import '../entities/solar.dart';

abstract class SolarRepo {
  const SolarRepo(
    this.solarRemoteDataSource,
    this.solarLocalDataSource,
  );

  final SolarRemoteDataSource solarRemoteDataSource;
  final SolarLocalDataSource solarLocalDataSource;

  Future<(List<SolarEntity>?, HttpError?)> fetch({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, HttpError?)> fetchRemote({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, HttpError?)> fetchLocal({
    DateTime? date,
  });

  Future<bool> createLocal(SolarEntity solar);

  Future<void> clearStorage();
}
