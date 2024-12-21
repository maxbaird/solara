import '../../../core/resources/solara_io_exception.dart';
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

  Future<(List<SolarEntity>?, SolaraIOException?)> fetch({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, SolaraIOException?)> fetchRemote({
    DateTime? date,
  });

  Future<(List<SolarEntity>?, SolaraIOException?)> fetchLocal({
    DateTime? date,
  });

  Future<bool> createLocal(SolarEntity solar);

  Future<void> clearStorage();
}
