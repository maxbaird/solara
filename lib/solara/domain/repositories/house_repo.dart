import '../../../core/resources/http_error.dart';
import '../entities/house.dart';

abstract class HouseRepo {
  Future<(List<HouseEntity>?, HttpError?)> fetch({
    DateTime? date,
  });
}
