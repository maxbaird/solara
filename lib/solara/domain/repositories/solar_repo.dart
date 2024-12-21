import '../../../core/resources/solara_io_error.dart';
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

  Future<(List<SolarEntity>?, SolaraIOError?)> fetch({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, SolaraIOError?)> fetchRemote({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, SolaraIOError?)> fetchLocal({
    DateTime? date,
  });

  Future<bool> createLocal(SolarEntity solar);

  Future<void> clearStorage();
}
