import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/battery_local_datasource.dart';
import 'package:solara/solara/data/models/battery_model.dart';

void main() {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
  final BatteryLocalDatasourceImpl batteryLocalDataSourceImpl =
      BatteryLocalDatasourceImpl(cacheName: 'batteryLocalDataSourceImpl');

  group('BatteryLocalDataSourceImpl.fetch()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await batteryLocalDataSourceImpl.clear();
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

    test('batteryLocalDataSource fetch: box does not exist', () async {
      var (results, err) =
          await batteryLocalDataSourceImpl.fetch(date: DateTime.now());
      expect(results, isNull);
      expect(err, isNotNull);
      expect(err is SolaraIOException, true);
      err = err as SolaraIOException;
      expect(err.type == IOExceptionType.localStorage, true);
    });

    test(
        'batteryLocalDataSource fetch: exception if hive box name is incorrect',
        () async {
      final BatteryLocalDatasourceImpl batteryLocalDataSourceImpl =
          BatteryLocalDatasourceImpl(cacheName: 'invalid');

      var (results, err) = await batteryLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNull);
      expect(err, isNotNull);
    });
  });

  group('BatteryLocalDataSource.create()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await batteryLocalDataSourceImpl.clear();
    });

    test('Successfully creates entry', () async {
      BatteryModel model = BatteryModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      bool result = await batteryLocalDataSourceImpl.create(model);
      expect(result, true);
    });

    test('Does not put entry if timestamp/date is null', () async {
      BatteryModel emptyModel = BatteryModel(date: null);

      bool result = await batteryLocalDataSourceImpl.create(emptyModel);
      expect(result, false);
    });

    test('Does not put entry it already exists', () async {
      BatteryModel model = BatteryModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await batteryLocalDataSourceImpl.create(model);
      bool result = await batteryLocalDataSourceImpl.create(model);

      expect(result, false);
    });
  });

  group('BatteryLocalDataSource.clear()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await batteryLocalDataSourceImpl.clear();
    });

    test('Box is cleared', () async {
      BatteryModel model = BatteryModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await batteryLocalDataSourceImpl.create(model);
      await batteryLocalDataSourceImpl.clear();

      var (results, err) = await batteryLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNotNull);
      expect(results!.isEmpty, true);
      expect(err, isNull);
    });
  });
}
