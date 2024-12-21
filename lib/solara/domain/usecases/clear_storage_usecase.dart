import '../../../core/use_case/use_case.dart';
import '../repositories/battery_repo.dart';

class ClearStorageUseCase implements UseCase<void, void> {
  const ClearStorageUseCase(this._batteryRepo);

  final BatteryRepo _batteryRepo;

  @override
  Future<void> call({required void params}) {
    _batteryRepo.clearStorage();
    return Future.value(null);
  }
}
