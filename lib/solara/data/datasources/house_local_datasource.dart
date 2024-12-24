import '../../../core/data/datasources/solara_persistence_interface.dart';
import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../models/house_model.dart';

/// The local data source for caching house data.
class HouseLocalDataSourceImpl implements HouseLocalDataSource {
  HouseLocalDataSourceImpl({required this.localStorage});

  @override
  final SolaraPersistenceInterface localStorage;

  final _log = logger;

  @override
  Future<(List<HouseModel>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    var (results, err) = await localStorage.readAll();

    if (err != null) {
      _log.w(
          'Error fetching data from $runtimeType: ${localStorage.storageName}');
      return (null, err);
    }

    _log.i('Fetched ${results.length} from $runtimeType cache');

    List<HouseModel> houseModels = _filterByDate(results, date);

    return (houseModels, null);
  }

  @override
  Future<bool> create(HouseModel model) async {
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
  Future<void> clear() async {
    var (result, err) = await localStorage.clearAll();

    if (err != null || !result) {
      _log.e('Error clearing local  storage: $err');
    }
  }

  /// Data fetched from the API can sometimes contain data from
  /// dates not requested.
  ///
  /// This function ensures that only data matching [date] is returned..
  List<HouseModel> _filterByDate(List<dynamic> resultItems, DateTime? date) {
    if (date == null) {
      return [];
    }

    List<HouseModel> houseModels = [];

    for (var item in resultItems) {
      HouseModel model = HouseModel.fromJson(Map<String, dynamic>.from(item));
      DateTime? modelDate = model.date;

      if (modelDate == null) {
        continue;
      }

      if (modelDate.year == date.year &&
          modelDate.month == date.month &&
          modelDate.day == date.day) {
        houseModels.add(model);
      }
    }
    return houseModels;
  }
}

abstract class HouseLocalDataSource {
  HouseLocalDataSource({required this.localStorage});

  /// Used for local storage IO.
  final SolaraPersistenceInterface localStorage;

  /// The fetch operation.
  ///
  /// Returns all cached data matching [date].
  Future<(List<HouseModel>?, SolaraIOException?)> fetch({
    required DateTime? date,
  });

  /// The create operation.
  ///
  /// Writes [model] to cache.
  Future<bool> create(HouseModel model);

  /// Clears all data written to cache.
  Future<void> clear();
}
