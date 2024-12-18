import '../entities/battery.dart';
import '../../../core/resources/http_error.dart';

abstract class BatteryRepo {
  Future<(List<BatteryEntity>?, HttpError?)> fetch({
    String? finder,
  });
}
