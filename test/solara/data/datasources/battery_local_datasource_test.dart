import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/solara/data/datasources/battery_local_datasource.dart';
import 'package:solara/solara/data/models/battery_model.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

void main() {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
  late final BatteryLocalDatasourceImpl batteryLocalDataSourceImpl;

  group('BatteryLocalDataSourceImpl', () {
    setUp(() async {
      final String cacheName = 'batteryLocalDataSourceImpl';
      batteryLocalDataSourceImpl =
          BatteryLocalDatasourceImpl(cacheName: cacheName);
    });
    test('battery local data source fetch', () async {
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
    tearDown(() async {
      batteryLocalDataSourceImpl.clear();
    });
  });
}
