import '../../domain/entities/house.dart';
import '../../../core/resources/http_error.dart';
import '../../domain/repositories/house_repo.dart';
import '../models/house_model.dart';

class HouseRepoImpl extends HouseRepo {
  const HouseRepoImpl(super.houseRemoteDataSource);

  @override
  Future<(List<HouseEntity>?, HttpError?)> fetch({DateTime? date}) async {
    var (houseEntities, err) = await houseRemoteDataSource.fetch(
      date: date,
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
