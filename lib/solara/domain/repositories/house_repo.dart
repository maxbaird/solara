import '../../../core/resources/http_error.dart';
import '../../data/datasources/house_remote_datasource.dart';
import '../entities/house.dart';

abstract class HouseRepo {
  const HouseRepo(this.houseRemoteDataSource);

  final HouseRemoteDataSource houseRemoteDataSource;

  Future<(List<HouseEntity>?, HttpError?)> fetch({
    DateTime? date,
  });
}
