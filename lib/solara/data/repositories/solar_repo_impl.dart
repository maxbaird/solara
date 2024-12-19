import '../../../core/resources/http_error.dart';
import '../../domain/entities/solar.dart';
import '../../domain/repositories/solar_repo.dart';
import '../models/solar_model.dart';

class SolarRepoImpl extends SolarRepo {
  const SolarRepoImpl(
    super.solarRemoteDataSource,
  );

  @override
  Future<(List<SolarEntity>?, HttpError?)> fetch({DateTime? date}) async {
    var (houseEntities, err) = await solarRemoteDataSource.fetch(
      date: date,
    );

    return (_toEntityList(houseEntities), err);
  }

  List<SolarEntity> _toEntityList(List<SolarModel>? models) {
    List<SolarEntity> entities = [];

    if (models == null) {
      return entities;
    }

    for (var model in models) {
      entities.add(model.toEntity());
    }

    return entities;
  }
}
