import '../../domain/entities/house.dart';
import '../../../core/resources/http_error.dart';
import '../../domain/repositories/house_repo.dart';
import '../datasources/house_remote_datasource.dart';
import '../models/house_model.dart';

class HouseRepoImpl implements HouseRepo {
  const HouseRepoImpl(
    this.houseRemoteDataSource,
  );

  final HouseRemoteDataSource houseRemoteDataSource;

  @override
  Future<(List<HouseEntity>?, HttpError?)> fetch({String? finder}) async {
    var (houseEntities, err) = await houseRemoteDataSource.fetch(
      finder: finder,
    );

    return (_toEntityList(houseEntities), err);
  }

  List<HouseEntity> _toEntityList(List<HouseModel>? models) {
    List<HouseEntity> entities = [];

    if (models == null) {
      return entities;
    }

    for (var model in models) {
      entities.add(model.toEntity());
    }

    return entities;
  }
}
