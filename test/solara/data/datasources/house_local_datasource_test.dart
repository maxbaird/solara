import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/data/datasources/solara_local_storage.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/house_local_datasource.dart';
import 'package:solara/solara/data/models/house_model.dart';

class MockSolaraLocalStorage extends Mock implements SolaraLocalStorage {
  @override
  String get storageName => 'solaraLocalStorage_test';
}

void main() {
  final mockSolaraLocalStorage = MockSolaraLocalStorage();
  final HouseLocalDataSourceImpl houseLocalDataSourceImpl =
      HouseLocalDataSourceImpl(localStorage: mockSolaraLocalStorage);

  setUpAll(() {
    registerFallbackValue(MockSolaraLocalStorage());
  });

  group('HouseLocalDataSourceImpl.fetch()', () {
    test('houseLocalDataSource fetch', () async {
      final date = DateTime.parse('2024-12-21T20:56:00.467Z');
      final model = HouseModel.fromJson(
          {'timestamp': date.toIso8601String(), 'value': 3630});

      when(() => mockSolaraLocalStorage.readAll())
          .thenAnswer((_) async => (<dynamic>[model.toJson()], null));

      var (results, err) = await houseLocalDataSourceImpl.fetch(date: date);

      expect(err, isNull);
      expect(results, isNotNull);
      expect(results!.length, 1);
      expect(results.first == model, true);
    });

    test('error when fetching', () async {
      when(() => mockSolaraLocalStorage.readAll())
          .thenAnswer((_) async => (null, SolaraIOException()));
      var (results, err) =
          await houseLocalDataSourceImpl.fetch(date: DateTime.now());
      expect(results, isNull);
      expect(err, isNotNull);
      expect(err is SolaraIOException, true);
      err = err as SolaraIOException;
    });
  });

  group('HouseLocalDataSource.create()', () {
    test('Successfully creates entry', () async {
      final model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      when(() => mockSolaraLocalStorage.write(any(), any()))
          .thenAnswer((_) async => (true, null));

      bool result = await houseLocalDataSourceImpl.create(model);
      expect(result, true);
    });

    test('Does not put entry if timestamp/date is null', () async {
      HouseModel emptyModel = HouseModel(date: null);

      bool result = await houseLocalDataSourceImpl.create(emptyModel);
      expect(result, false);
    });

    test('reports creation error', () async {
      final model = HouseModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630});

      when(() => mockSolaraLocalStorage.write(any(), any())).thenAnswer(
          (_) async =>
              (false, SolaraIOException(type: IOExceptionType.localStorage)));

      bool result = await houseLocalDataSourceImpl.create(model);

      expect(result, false);
    });
  });

  group('HouseLocalDataSource.clear()', () {
    test('storage cleared succeeds', () async {
      when(() => mockSolaraLocalStorage.clearAll())
          .thenAnswer((_) async => (true, null));
      final result = await houseLocalDataSourceImpl.clear();

      expect(result, true);
    });

    test('storage cleared fails', () async {
      when(() => mockSolaraLocalStorage.clearAll())
          .thenAnswer((_) async => (false, SolaraIOException()));

      final result = await houseLocalDataSourceImpl.clear();

      expect(result, false);
    });
  });
}
