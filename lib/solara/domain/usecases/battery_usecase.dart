import '../../../core/params/fetch_params.dart';
import '../../../core/resources/solara_io_exception.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/battery.dart';
import '../repositories/battery_repo.dart';

/// The use case for fetching battery entities.
class FetchBatteryUseCase
    implements
        UseCase<(List<BatteryEntity>?, SolaraIOException?), FetchParams> {
  const FetchBatteryUseCase(this._batteryRepo);

  /// The repository used for the fetch.
  final BatteryRepo _batteryRepo;

  @override
  Future<(List<BatteryEntity>?, SolaraIOException?)> call({
    required FetchParams params,
  }) {
    return _batteryRepo.fetch(date: params.date);
  }
}
