import '../../../core/params/fetch_params.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/house.dart';
import '../repositories/house_repo.dart';

class FetchHouseUseCase
    implements UseCase<(List<HouseEntity>?, HttpError?), FetchParams> {
  const FetchHouseUseCase(this._houseRepo);

  final HouseRepo _houseRepo;

  @override
  Future<(List<HouseEntity>?, HttpError?)> call({
    required FetchParams params,
  }) {
    return _houseRepo.fetch(finder: params.finder);
  }
}
