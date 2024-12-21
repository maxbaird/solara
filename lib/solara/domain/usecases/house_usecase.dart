import '../../../core/params/fetch_params.dart';
import '../../../core/resources/solara_io_exception.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/house.dart';
import '../repositories/house_repo.dart';

class FetchHouseUseCase
    implements UseCase<(List<HouseEntity>?, SolaraIOException?), FetchParams> {
  const FetchHouseUseCase(this._houseRepo);

  final HouseRepo _houseRepo;

  @override
  Future<(List<HouseEntity>?, SolaraIOException?)> call({
    required FetchParams params,
  }) {
    return _houseRepo.fetch(date: params.date);
  }
}
