import '../../../core/resources/http_error.dart';
import '../entities/solar.dart';

abstract class SolarRepo {
  Future<(List<SolarEntity>?, HttpError?)> fetch({
    String? finder,
  });
}
