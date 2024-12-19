import '../../../core/params/fetch_params.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/battery.dart';
import '../repositories/battery_repo.dart';

class FetchBatteryUseCase
    implements UseCase<(List<BatteryEntity>?, HttpError?), FetchParams> {
  const FetchBatteryUseCase(this._batteryRepo);

  final BatteryRepo _batteryRepo;

  @override
  Future<(List<BatteryEntity>?, HttpError?)> call({
    required FetchParams params,
  }) {
    return _batteryRepo.fetch(date: params.date);
  }
}
