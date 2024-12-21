import 'package:get_it/get_it.dart';

import 'core/constants/constants.dart';
import 'core/util/repo_config.dart';
import 'solara/data/datasources/battery_local_datasource.dart';
import 'solara/data/datasources/battery_remote_datasource.dart';
import 'solara/data/datasources/house_local_data_source.dart';
import 'solara/data/datasources/house_remote_datasource.dart';
import 'solara/data/datasources/solar_local_datasource.dart';
import 'solara/data/datasources/solar_remote_datasource.dart';
import 'solara/data/repositories/battery_repo_impl.dart';
import 'solara/data/repositories/house_repo_impl.dart';
import 'solara/data/repositories/solar_repo_impl.dart';
import 'solara/domain/repositories/battery_repo.dart';
import 'solara/domain/repositories/house_repo.dart';
import 'solara/domain/repositories/solar_repo.dart';
import 'solara/domain/usecases/battery_usecase.dart';
import 'solara/domain/usecases/clear_storage_usecase.dart';
import 'solara/domain/usecases/house_usecase.dart';
import 'solara/domain/usecases/solar_usecase.dart';
import 'solara/presentation/flows/battery/bloc/battery_bloc.dart';
import 'solara/presentation/flows/house/bloc/house_bloc.dart';
import 'solara/presentation/flows/solar/bloc/solar_bloc.dart';

final GetIt sl = GetIt.instance;
final RepoConfig solaraRepoConfig = RepoConfig(baseUrl: baseUrl);

void init() {
  final BatteryLocalDataSource batteryLocalDataSource =
      BatteryLocalDatasourceImpl(solaraRepoConfig);
  final BatteryRemoteDataSource batteryRemoteDataSource =
      BatteryRemoteDataSourceImpl(solaraRepoConfig, '/monitoring');

  sl.registerLazySingleton<BatteryRepo>(
    () => BatteryRepoImpl(
      batteryRemoteDataSource,
      batteryLocalDataSource,
    ),
  );

  final HouseLocalDataSource houseLocalDataSource =
      HouseLocalDatasourceImpl(solaraRepoConfig);
  final HouseRemoteDataSource houseRemoteDataSource =
      HouseRemoteDataSourceImpl(solaraRepoConfig, '/monitoring');

  sl.registerLazySingleton<HouseRepo>(
    () => HouseRepoImpl(
      houseRemoteDataSource,
      houseLocalDataSource,
    ),
  );

  final SolarLocalDataSource solarLocalDataSource =
      SolarLocalDatasourceImpl(solaraRepoConfig);
  final SolarRemoteDataSource solarRemoteDataSource =
      SolarRemoteDataSourceImpl(solaraRepoConfig, '/monitoring');

  sl.registerLazySingleton<SolarRepo>(
    () => SolarRepoImpl(
      solarRemoteDataSource,
      solarLocalDataSource,
    ),
  );

  sl.registerLazySingleton<FetchBatteryUseCase>(
    () => FetchBatteryUseCase(sl()),
  );

  sl.registerLazySingleton<FetchHouseUseCase>(
    () => FetchHouseUseCase(sl()),
  );

  sl.registerLazySingleton<FetchSolarUseCase>(
    () => FetchSolarUseCase(sl()),
  );

  sl.registerLazySingleton<ClearStorageUseCase>(
    () => ClearStorageUseCase(sl()),
  );

  sl.registerFactory<HouseBloc>(() => HouseBloc(fetchHouseUseCase: sl()));
  sl.registerFactory<BatteryBloc>(() => BatteryBloc(fetchBatteryUseCase: sl()));
  sl.registerFactory<SolarBloc>(() => SolarBloc(fetchSolarUseCase: sl()));
}
