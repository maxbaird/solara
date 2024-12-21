import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../models/house_model.dart';

class HouseLocalDatasourceImpl implements HouseLocalDataSource {
  HouseLocalDatasourceImpl({String? cacheName}) {
    _cacheName = cacheName ?? runtimeType.toString();
  }

  late final String _cacheName;

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
      _cache?.clear();
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
  Future<(List<HouseModel>?, SolaraIOException?)> fetch({
    required DateTime? date,
  });

  Future<bool> create(HouseModel model);

  Future<void> clear();
}
