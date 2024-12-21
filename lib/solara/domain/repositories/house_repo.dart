import '../../../core/resources/solara_io_exception.dart';
import '../../data/datasources/house_local_data_source.dart';
import '../../data/datasources/house_remote_datasource.dart';
import '../entities/house.dart';

abstract class HouseRepo {
  const HouseRepo(
    this.houseRemoteDataSource,
    this.houseLocalDataSource,
  );

  final HouseRemoteDataSource houseRemoteDataSource;
  final HouseLocalDataSource houseLocalDataSource;

  Future<(List<HouseEntity>?, SolaraIOException?)> fetch({
    DateTime? date,
  });

  Future<(List<HouseEntity>?, SolaraIOException?)> fetchRemote({
    DateTime? date,
  });

  Future<(List<HouseEntity>?, SolaraIOException?)> fetchLocal({
    DateTime? date,
  });

  Future<bool> createLocal(HouseEntity house);

  Future<void> clearStorage();
}
