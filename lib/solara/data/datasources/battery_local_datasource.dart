import 'package:solara/core/data/datasources/solara_persistence_interface.dart';

import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../models/battery_model.dart';

/// The local data source for caching battery data.
class BatteryLocalDataSourceImpl implements BatteryLocalDataSource {
  BatteryLocalDataSourceImpl({required this.localStorage});

  @override
  final SolaraPersistenceInterface localStorage;

  final _log = logger;

  @override
  Future<(List<BatteryModel>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    var (results, err) = await localStorage.readAll();

    if (err != null) {
      _log.w(
          'Error fetching data from $runtimeType: ${localStorage.storageName}');
      return (null, err);
    }

    _log.i('Fetched ${results.length} from $runtimeType cache');

    List<BatteryModel> batteryModels = _filterByDate(results, date);

    return (batteryModels, null);
  }

  @override
  Future<bool> create(BatteryModel model) async {
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
  List<BatteryModel> _filterByDate(List<dynamic> resultItems, DateTime? date) {
    if (date == null) {
      return [];
    }

    List<BatteryModel> batteryModels = [];

    for (var item in resultItems) {
      BatteryModel model =
          BatteryModel.fromJson(Map<String, dynamic>.from(item));
      DateTime? modelDate = model.date;

      if (modelDate == null) {
        continue;
      }

      if (modelDate.year == date.year &&
          modelDate.month == date.month &&
          modelDate.day == date.day) {
        batteryModels.add(model);
      }
    }
    return batteryModels;
  }
}

abstract class BatteryLocalDataSource {
  BatteryLocalDataSource({required this.localStorage});

  /// Used for local storage IO.
  final SolaraPersistenceInterface localStorage;

  /// The fetch operation.
  ///
  /// Returns all cached data matching [date].
  Future<(List<BatteryModel>?, SolaraIOException?)> fetch({
    required DateTime? date,
  });

  /// The create operation.
  ///
  /// Writes [model] to cache.
  Future<bool> create(BatteryModel model);

  /// Clears all data written to cache.
  Future<void> clear();
}
