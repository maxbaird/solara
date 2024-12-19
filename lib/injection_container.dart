import 'package:get_it/get_it.dart';

import 'core/constants/constants.dart';
import 'core/util/repo_config.dart';
import 'solara/data/datasources/battery_remote_datasource.dart';
import 'solara/data/datasources/house_remote_datasource.dart';
import 'solara/data/datasources/solar_remote_datasource.dart';
import 'solara/data/repositories/battery_repo_impl.dart';
import 'solara/data/repositories/house_repo_impl.dart';
import 'solara/data/repositories/solar_repo_impl.dart';
import 'solara/domain/repositories/battery_repo.dart';
import 'solara/domain/repositories/house_repo.dart';
import 'solara/domain/repositories/solar_repo.dart';
import 'solara/domain/usecases/battery_usecase.dart';

final GetIt sl = GetIt.instance;
final RepoConfig solaraRepoConfig = RepoConfig(baseUrl: baseUrl);

void init() {
  sl.registerLazySingleton<BatteryRemoteDataSource>(
    () => BatteryRemoteDataSourceImpl(solaraRepoConfig, '/monitoring'),
  );

  sl.registerLazySingleton<HouseRemoteDataSource>(
    () => HouseRemoteDataSourceImpl(solaraRepoConfig, '/monitoring'),
  );

  sl.registerLazySingleton<SolarRemoteDataSource>(
    () => SolarRemoteDataSourceImpl(solaraRepoConfig, '/monitoring'),
  );

  sl.registerLazySingleton<BatteryRepo>(
    () => BatteryRepoImpl(sl()),
  );

  sl.registerLazySingleton<HouseRepo>(
    () => HouseRepoImpl(sl()),
  );

  sl.registerLazySingleton<SolarRepo>(
    () => SolarRepoImpl(sl()),
  );

  sl.registerLazySingleton<FetchBatteryUseCase>(
    () => FetchBatteryUseCase(sl()),
  );
}
