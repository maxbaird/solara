import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/resources/solara_io_error.dart';
import 'package:solara/solara/data/datasources/battery_local_datasource.dart';
import 'package:solara/solara/data/models/battery_model.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

void main() {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
  final BatteryLocalDatasourceImpl batteryLocalDataSourceImpl =
      BatteryLocalDatasourceImpl(cacheName: 'batteryLocalDataSourceImpl');

  group('BatteryLocalDataSourceImpl', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await batteryLocalDataSourceImpl.clear();
      // await Hive.close();
    });

    test('batteryLocalDataSource fetch', () async {
      BatteryModel model = BatteryModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await batteryLocalDataSourceImpl.create(model);

      var (results, err) = await batteryLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(err, isNull);
      expect(results, isNotNull);
      expect(results!.length, 1);
      expect(results.first == model, true);
    });

    test('batteryLocalDataSource fetch box does not exist', () async {
      var (results, err) =
          await batteryLocalDataSourceImpl.fetch(date: DateTime.now());
      expect(results, isNull);
      expect(err, isNotNull);
      expect(err is SolaraIOError, true);
      err = err as SolaraIOError;
      expect(err.type == IOExceptionType.localStorage, true);
    });
  });
}
