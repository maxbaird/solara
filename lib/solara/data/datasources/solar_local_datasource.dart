import '../../../core/data/datasources/solara_persistence_interface.dart';
import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../models/solar_model.dart';

/// The local data source for caching solar data.
class SolarLocalDataSourceImpl implements SolarLocalDataSource {
  SolarLocalDataSourceImpl({required this.localStorage});

  @override
  final SolaraPersistenceInterface localStorage;

  final _log = logger;

  @override
  Future<(List<SolarModel>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    var (results, err) = await localStorage.readAll();

    if (err != null) {
      _log.w(
          'Error fetching data from $runtimeType: ${localStorage.storageName}');
      return (null, err);
    }

    _log.i('Fetched ${results.length} from $runtimeType cache');

    List<SolarModel> batteryModels = _filterByDate(results, date);

    return (batteryModels, null);
  }

  @override
  Future<bool> create(SolarModel model) async {
    final String? key = model.date?.toIso8601String();

    if (key == null) {
      return false;
    }

    var (result, err) = await localStorage.write(key, model.toJson());

    if (err != null) {
      _log.e('Error writing to local  storage: $err');
    }
    return result;
  }

  @override
  Future<bool> clear() async {
    var (result, err) = await localStorage.clearAll();

    if (err != null || !result) {
      _log.e('Error clearing local  storage: $err');
    }

    return result;
  }

  /// Data fetched from the API can sometimes contain data from
  /// dates not requested.
  ///
  /// This function ensures that only data matching [date] is returned..
  List<SolarModel> _filterByDate(List<dynamic> resultItems, DateTime? date) {
    if (date == null) {
      return [];
    }

    List<SolarModel> solarModels = [];

    for (var item in resultItems) {
      SolarModel model = SolarModel.fromJson(Map<String, dynamic>.from(item));
      DateTime? modelDate = model.date;

      if (modelDate == null) {
        continue;
      }

      if (modelDate.year == date.year &&
          modelDate.month == date.month &&
          modelDate.day == date.day) {
        solarModels.add(model);
      }
    }
    return solarModels;
  }
}

abstract class SolarLocalDataSource {
  SolarLocalDataSource({required this.localStorage});

  /// Used for local storage IO.
  final SolaraPersistenceInterface localStorage;

  /// The fetch operation.
  ///
  /// Returns all cached data matching [date].
  Future<(List<SolarModel>?, SolaraIOException?)> fetch({
    required DateTime? date,
  });

  /// The create operation.
  ///
  /// Writes [model] to cache.
  Future<bool> create(SolarModel model);

  /// Clears all data written to cache.
  Future<bool> clear();
}
