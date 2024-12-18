import '../../../core/params/fetch_params.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/solar.dart';
import '../repositories/solar_repo.dart';

class FetchSolarUseCase
    implements UseCase<(List<SolarEntity>?, HttpError?), FetchParams> {
  const FetchSolarUseCase(this._solarRepo);

  final SolarRepo _solarRepo;

  @override
  Future<(List<SolarEntity>?, HttpError?)> call({
    required FetchParams params,
  }) {
    return _solarRepo.fetch(finder: params.finder);
  }
}
