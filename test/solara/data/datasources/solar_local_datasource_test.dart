import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/solar_local_datasource.dart';
import 'package:solara/solara/data/models/solar_model.dart';

void main() {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
  final SolarLocalDatasourceImpl solarLocalDataSourceImpl =
      SolarLocalDatasourceImpl(cacheName: 'solarLocalDataSourceImpl');

  group('SolarLocalDataSourceImpl.fetch()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await solarLocalDataSourceImpl.clear();
    });

    test('solarLocalDataSource fetch', () async {
      SolarModel model = SolarModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await solarLocalDataSourceImpl.create(model);

      var (results, err) = await solarLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(err, isNull);
      expect(results, isNotNull);
      expect(results!.length, 1);
      expect(results.first == model, true);
    });

    test('solarLocalDataSource fetch: box does not exist', () async {
      var (results, err) =
          await solarLocalDataSourceImpl.fetch(date: DateTime.now());
      expect(results, isNull);
      expect(err, isNotNull);
      expect(err is SolaraIOException, true);
      err = err as SolaraIOException;
      expect(err.type == IOExceptionType.localStorage, true);
    });

    test('solarLocalDataSource fetch: exception if hive box name is incorrect',
        () async {
      final SolarLocalDatasourceImpl solarLocalDataSourceImpl =
          SolarLocalDatasourceImpl(cacheName: 'invalid');

      var (results, err) = await solarLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNull);
      expect(err, isNotNull);
    });
  });

  group('SolarLocalDataSource.create()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await solarLocalDataSourceImpl.clear();
    });

    test('Successfully creates entry', () async {
      SolarModel model = SolarModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      bool result = await solarLocalDataSourceImpl.create(model);
      expect(result, true);
    });

    test('Does not put entry if timestamp/date is null', () async {
      SolarModel emptyModel = SolarModel(date: null);

      bool result = await solarLocalDataSourceImpl.create(emptyModel);
      expect(result, false);
    });

    test('Does not put entry it already exists', () async {
      SolarModel model = SolarModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await solarLocalDataSourceImpl.create(model);
      bool result = await solarLocalDataSourceImpl.create(model);

      expect(result, false);
    });
  });

  group('SolarLocalDataSource.clear()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await solarLocalDataSourceImpl.clear();
    });

    test('Box is cleared', () async {
      SolarModel model = SolarModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await solarLocalDataSourceImpl.create(model);
      await solarLocalDataSourceImpl.clear();

      var (results, err) = await solarLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNotNull);
      expect(results!.isEmpty, true);
      expect(err, isNull);
    });
  });
}
