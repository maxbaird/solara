import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/house_local_data_source.dart';
import 'package:solara/solara/data/models/house_model.dart';

void main() {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
  final HouseLocalDatasourceImpl houseLocalDataSourceImpl =
      HouseLocalDatasourceImpl(cacheName: 'houseLocalDataSourceImpl');

  group('HouseLocalDataSourceImpl.fetch()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await houseLocalDataSourceImpl.clear();
    });

    test('houseLocalDataSource fetch', () async {
      HouseModel model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await houseLocalDataSourceImpl.create(model);

      var (results, err) = await houseLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(err, isNull);
      expect(results, isNotNull);
      expect(results!.length, 1);
      expect(results.first == model, true);
    });

    test('houseLocalDataSource fetch: box does not exist', () async {
      var (results, err) =
          await houseLocalDataSourceImpl.fetch(date: DateTime.now());
      expect(results, isNull);
      expect(err, isNotNull);
      expect(err is SolaraIOException, true);
      err = err as SolaraIOException;
      expect(err.type == IOExceptionType.localStorage, true);
    });

    test('houseLocalDataSource fetch: exception if hive box name is incorrect',
        () async {
      final HouseLocalDatasourceImpl houseLocalDataSourceImpl =
          HouseLocalDatasourceImpl(cacheName: 'invalid');

      var (results, err) = await houseLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNull);
      expect(err, isNotNull);
    });
  });

  group('HouseLocalDataSource.create()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await houseLocalDataSourceImpl.clear();
    });

    test('Successfully creates entry', () async {
      HouseModel model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      bool result = await houseLocalDataSourceImpl.create(model);
      expect(result, true);
    });

    test('Does not put entry if timestamp/date is null', () async {
      HouseModel emptyModel = HouseModel(date: null);

      bool result = await houseLocalDataSourceImpl.create(emptyModel);
      expect(result, false);
    });

    test('Does not put entry it already exists', () async {
      HouseModel model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await houseLocalDataSourceImpl.create(model);
      bool result = await houseLocalDataSourceImpl.create(model);

      expect(result, false);
    });
  });

  group('HouseLocalDataSource.clear()', () {
    setUp(() async {
      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await houseLocalDataSourceImpl.clear();
    });

    test('Box is cleared', () async {
      HouseModel model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      await houseLocalDataSourceImpl.create(model);
      await houseLocalDataSourceImpl.clear();

      var (results, err) = await houseLocalDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(results, isNotNull);
      expect(results!.isEmpty, true);
      expect(err, isNull);
    });
  });
}
