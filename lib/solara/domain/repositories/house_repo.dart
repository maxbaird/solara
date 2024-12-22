import '../../../core/resources/solara_io_exception.dart';
import '../../data/datasources/house_local_datasource.dart';
import '../../data/datasources/house_remote_datasource.dart';
import '../entities/house.dart';

/// This class defines the interface for populating its domain entity. The
/// concrete implementation for [HouseRepo] is in the data layer. This way,
/// the details concerning how the data is fetched and processed are of no
/// concern to the domain. There is no tight coupling.
///
/// [HouseRepo]'s concrete implementation masks all the details of data fetching.
abstract class HouseRepo {
  const HouseRepo(
    this.houseRemoteDataSource,
    this.houseLocalDataSource,
  );

  /// The remote data source for this repository.
  final HouseRemoteDataSource houseRemoteDataSource;

  /// The local data source for this repository.
  final HouseLocalDataSource houseLocalDataSource;

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
  Future<(List<HouseEntity>?, SolaraIOException?)> fetch({
    DateTime? date,
  });

  /// Fetches data from the remote data source.
  ///
  /// Any errors will result in null being returned instead of an entity list.
  /// Further details of the error are contained in the second field of the
  /// Future's record.
  Future<(List<HouseEntity>?, SolaraIOException?)> fetchRemote({
    DateTime? date,
  });

  /// Fetches data from the local data source.
  ///
  /// Any errors will result in null being returned instead of an entity list.
  /// Further details of the error are contained in the second field of the
  /// Future's record.
  Future<(List<HouseEntity>?, SolaraIOException?)> fetchLocal({
    DateTime? date,
  });

  /// Inserts an entity into the local cache.
  ///
  /// Returns true if the entity was stored successfully.
  Future<bool> createLocal(HouseEntity house);

  /// Clears the storage of ALL [HouseEntity].
  Future<void> clearStorage();
}
