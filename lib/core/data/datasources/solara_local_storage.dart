import 'package:hive_flutter/hive_flutter.dart';

import '../../resources/solara_io_exception.dart';
import '../../util/logger.dart';
import 'solara_persistence_interface.dart';

class SolaraLocalStorage implements SolaraPersistenceInterface {
  SolaraLocalStorage({required this.storageName});

  Box<dynamic>? _cache;
  final _log = logger;

  @override
  final String storageName;

  @override
  Future<(bool, SolaraIOException?)> init() async {
    try {
      await Hive.initFlutter();
      return (true, null);
    } catch (e) {
      final String err = 'Error initializing $storageName';
      _log.e(err);
      return (
        false,
        SolaraIOException(error: err, type: IOExceptionType.localStorage)
      );
    }
  }

  @override
  Future<(dynamic, SolaraIOException?)> readAll() async {
    try {
      if (!await Hive.boxExists(storageName)) {
        final err = 'Local storage for $storageName not found';
        _log.w(err);
        return (
          null,
          SolaraIOException(type: IOExceptionType.localStorage, error: err)
        );
      }

      await _openStorage();
      final List<dynamic> resultItems = _cache!.values.toList();

      await _closeStorage();

      return (resultItems, null);
    } catch (e) {
      _log.e('Error fetching data for $storageName: $e');
      return (
        null,
        SolaraIOException(error: e, type: IOExceptionType.localStorage)
      );
    }
  }

  @override
  Future<(bool, SolaraIOException?)> write(String key, dynamic value) async {
    try {
      await _openStorage();

      if (_cache!.containsKey(key)) {
        return (
          false,
          SolaraIOException(
              error: 'Data for $key already exists',
              type: IOExceptionType.localStorage)
        );
      }
      await _cache!.put(key, value);
      await _closeStorage();
      return (true, null);
    } catch (e) {
      final err = 'Error writing data for $key: $e';
      _log.e(err);
      return (
        false,
        SolaraIOException(error: err, type: IOExceptionType.localStorage)
      );
    }
  }

  @override
  Future<(bool, SolaraIOException?)> clearAll() async {
    try {
      await _openStorage();
      await _cache?.clear();
      _log.i('Cleared $storageName local storage');
      return (true, null);
    } catch (e) {
      final err = 'Error clearing storage for $storageName: $e';
      _log.e(err);
      return (
        false,
        SolaraIOException(error: err, type: IOExceptionType.localStorage)
      );
    }
  }

  Future<bool> _openStorage() async {
    if (Hive.isBoxOpen(storageName)) {
      return true;
    }

    _cache = await Hive.openBox(storageName);
    return true;
  }

  Future<bool> _closeStorage() async {
    /// Not necessary according to docs:
    /// [https://docs.hivedb.dev/#/basics/boxes?id=close-box]
    await _cache?.close();
    return true;
  }
}
