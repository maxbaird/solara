import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../models/house_model.dart';

/// The local data source for caching house data.
class HouseLocalDatasourceImpl implements HouseLocalDataSource {
  HouseLocalDatasourceImpl({String? cacheName}) {
    _cacheName = cacheName ?? runtimeType.toString();
  }

  /// The name of the data cache.
  late final String _cacheName;

  /// The container used for the cache.
  Box<dynamic>? _cache;
  final _log = logger;

  @override
  Future<(List<HouseModel>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    try {
      if (!await Hive.boxExists(_cacheName)) {
        _log.w('Hive Box for HouseDataSourceImpl not found');
        return (
          null,
          SolaraIOException(
              type: IOExceptionType.localStorage,
              error: 'Cache for HouseDataSourceImpl not found')
        );
      }

      await _openStorage();

      final List<dynamic> resultItems = _cache!.values.toList();

      /// Filter any data that is not associated with [date].
      List<HouseModel> houseModels = _filterByDate(resultItems, date);

      _log.i(
          'Fetched ${houseModels.length} from HouseModelLocalDataSourceImpl cache');
      await _closeStorage();
      return (houseModels, null);
    } catch (e) {
      _log.e('Error fetching data from HouseDataSourceImpl: $_cacheName: $e');
      return (null, SolaraIOException(error: e));
    }
  }

  @override
  Future<bool> create(HouseModel model) async {
    final String? key = model.date?.toIso8601String();

    if (key == null) {
      return false;
    }

    await _openStorage();

    /// Don't write to cache if data for [key] already exists.
    if (_cache!.containsKey(key)) {
      return false;
    }

    await _cache!.put(key, model.toJson());
    await _closeStorage();
    return true;
  }

  @override
  Future<void> clear() async {
    await _openStorage();
    try {
      await _cache?.clear();
      _log.i('Cleared HouseLocalDataSourceImpl local storage');
    } catch (e) {
      _log.e(e);
      rethrow;
    }
  }

  Future<bool> _openStorage() async {
    if (Hive.isBoxOpen(_cacheName)) {
      return true;
    }

    _cache = await Hive.openBox(_cacheName);
    return true;
  }

  Future<bool> _closeStorage() async {
    /// Not necessary according to docs:
    /// [https://docs.hivedb.dev/#/basics/boxes?id=close-box]
    await _cache?.close();
    return true;
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
