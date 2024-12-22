import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/solar_local_datasource.dart';
import 'package:solara/solara/data/datasources/solar_remote_datasource.dart';
import 'package:solara/solara/data/models/solar_model.dart';
import 'package:solara/solara/data/repositories/solar_repo_impl.dart';

class MockSolarRemoteDataSource extends Mock implements SolarRemoteDataSource {}

class MockSolarLocalDataSource extends Mock implements SolarLocalDataSource {}

void main() {
  final mockSolarRemoteDataSource = MockSolarRemoteDataSource();
  final mockSolarLocalDataSource = MockSolarLocalDataSource();
  final solarRepoImpl =
      SolarRepoImpl(mockSolarRemoteDataSource, mockSolarLocalDataSource);

  final List<SolarModel> localSolarModels = [
    SolarModel(date: DateTime.now(), watts: 1000),
    SolarModel(date: DateTime.now(), watts: 2000),
    SolarModel(date: DateTime.now(), watts: 3000),
  ];

  final List<SolarModel> remoteSolarModels = [
    SolarModel(date: DateTime.now(), watts: 1000),
    SolarModel(date: DateTime.now(), watts: 2000),
    SolarModel(date: DateTime.now(), watts: 3000),
  ];

  setUpAll(() {
    registerFallbackValue(SolarModel());
  });

  group('SolarRepoImpl', () {
    setUp(() {
      reset(mockSolarRemoteDataSource);
      reset(mockSolarLocalDataSource);
      when(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((localSolarModels, null)));

      when(() => mockSolarRemoteDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((remoteSolarModels, null)));
    });

    test('fetch', () async {
      var (result, err) = await solarRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
    });

    test('fetch local only', () async {
      var (result, err) = await solarRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, localSolarModels.length);
      verify(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);
      verifyNever(
          () => mockSolarRemoteDataSource.fetch(date: any(named: 'date')));

      for (int i = 0; i != localSolarModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(localSolarModels[i].date!);
        bool wattsEqual = result[i].watts == localSolarModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('fetch remote only', () async {
      when(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockSolarLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await solarRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteSolarModels.length);

      verify(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockSolarRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      for (int i = 0; i != remoteSolarModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(remoteSolarModels[i].date!);
        bool wattsEqual = result[i].watts == remoteSolarModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('Caching after remote fetch', () async {
      when(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockSolarLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await solarRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteSolarModels.length);

      verify(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockSolarRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockSolarLocalDataSource.create(any()))
          .called(remoteSolarModels.length);
    });

    test('Remote fetch fails', () async {
      when(() => mockSolarLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockSolarRemoteDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value(
              (null, SolaraIOException(type: IOExceptionType.other))));

      var (result, err) = await solarRepoImpl.fetch(date: DateTime.now());

      expect(result, isNotNull);
      expect(result!.isEmpty, true);
      expect(err is SolaraIOException, true);
    });
  });
}
