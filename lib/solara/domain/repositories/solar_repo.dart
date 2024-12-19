import '../../../core/resources/http_error.dart';
import '../../data/datasources/solar_remote_datasource.dart';
import '../entities/solar.dart';

abstract class SolarRepo {
  const SolarRepo(this.solarRemoteDataSource);

  final SolarRemoteDataSource solarRemoteDataSource;

  Future<(List<SolarEntity>?, HttpError?)> fetch({
    DateTime? date,
  });
}
