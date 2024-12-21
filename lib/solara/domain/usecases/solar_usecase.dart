import '../../../core/params/fetch_params.dart';
import '../../../core/resources/solara_io_error.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/solar.dart';
import '../repositories/solar_repo.dart';

class FetchSolarUseCase
    implements UseCase<(List<SolarEntity>?, SolaraIOError?), FetchParams> {
  const FetchSolarUseCase(this._solarRepo);

  final SolarRepo _solarRepo;

  @override
  Future<(List<SolarEntity>?, SolaraIOError?)> call({
    required FetchParams params,
  }) {
    return _solarRepo.fetch(date: params.date);
  }
}
