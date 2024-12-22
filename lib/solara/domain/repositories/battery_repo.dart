import '../../../core/resources/solara_io_exception.dart';
import '../../data/datasources/battery_local_datasource.dart';
import '../../data/datasources/battery_remote_datasource.dart';
import '../entities/battery.dart';

/// This class defines the interface for populating its domain entity. The
/// concrete implementation for [BatteryRepo] is in the data layer. This way,
/// the details concerning how the data is fetched and processed are of no
/// concern to the domain. There is no tight coupling.
///
/// [BatteryRepo]'s concrete implementation masks all the details of data fetching.
abstract class BatteryRepo {
  const BatteryRepo(
    this.batteryRemoteDataSource,
    this.batteryLocalDataSource,
  );

  /// The remote data source for this repository.
  final BatteryRemoteDataSource batteryRemoteDataSource;

  /// The local data source for this repository.
  final BatteryLocalDataSource batteryLocalDataSource;

  /// This is a generic fetch that decides which data source is used when
  /// fetching.
  ///
  /// Ideally, its implementation should try to fetch from the local (cached)
  /// data source first. And if the local data source does not have a cached
  /// version of the data then the remote data source is used. All data returned
  /// by the remote data source should be cached.
  ///
  /// Any errors will result in null being returned instead of an entity list.
  /// Further details of the error are contained in the second field of the
  /// Future's record.
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetch({
    DateTime? date,
  });

  /// Fetches data from the remote data source.
  ///
  /// Any errors will result in null being returned instead of an entity list.
  /// Further details of the error are contained in the second field of the
  /// Future's record.
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchRemote({
    DateTime? date,
  });

  /// Fetches data from the local data source.
  ///
  /// Any errors will result in null being returned instead of an entity list.
  /// Further details of the error are contained in the second field of the
  /// Future's record.
  Future<(List<BatteryEntity>?, SolaraIOException?)> fetchLocal({
    DateTime? date,
  });

  /// Inserts an entity into the local cache.
  ///
  /// Returns true if the entity was stored successfully.
  Future<bool> createLocal(BatteryEntity battery);

  /// Clears the storage of ALL [BatteryEntity].
  Future<void> clearStorage();
}
