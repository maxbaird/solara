import '../../../core/use_case/use_case.dart';
import '../repositories/battery_repo.dart';
import '../repositories/house_repo.dart';
import '../repositories/solar_repo.dart';

class ClearStorageUseCase implements UseCase<void, void> {
  const ClearStorageUseCase(
    this._batteryRepo,
    this._solarRepo,
    this._houseRepo,
  );

  final BatteryRepo _batteryRepo;
  final SolarRepo _solarRepo;
  final HouseRepo _houseRepo;

  @override
  Future<void> call({required void params}) {
    _batteryRepo.clearStorage();
    _solarRepo.clearStorage();
    _houseRepo.clearStorage();
    return Future.value(null);
  }
}
