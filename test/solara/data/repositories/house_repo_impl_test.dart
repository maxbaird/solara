import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/data/datasources/house_local_datasource.dart';
import 'package:solara/solara/data/datasources/house_remote_datasource.dart';
import 'package:solara/solara/data/models/house_model.dart';
import 'package:solara/solara/data/repositories/house_repo_impl.dart';

class MockHouseRemoteDataSource extends Mock implements HouseRemoteDataSource {}

class MockHouseLocalDataSource extends Mock implements HouseLocalDataSource {}

void main() {
  final mockHouseRemoteDataSource = MockHouseRemoteDataSource();
  final mockHouseLocalDataSource = MockHouseLocalDataSource();
  final houseRepoImpl =
      HouseRepoImpl(mockHouseRemoteDataSource, mockHouseLocalDataSource);

  final List<HouseModel> localHouseModels = [
    HouseModel(date: DateTime.now(), watts: 1000),
    HouseModel(date: DateTime.now(), watts: 2000),
    HouseModel(date: DateTime.now(), watts: 3000),
  ];

  final List<HouseModel> remoteHouseModels = [
    HouseModel(date: DateTime.now(), watts: 1000),
    HouseModel(date: DateTime.now(), watts: 2000),
    HouseModel(date: DateTime.now(), watts: 3000),
  ];

  setUpAll(() {
    registerFallbackValue(HouseModel());
  });

  group('HouseRepoImpl', () {
    setUp(() {
      reset(mockHouseRemoteDataSource);
      reset(mockHouseLocalDataSource);
      when(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((localHouseModels, null)));

      when(() => mockHouseRemoteDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((remoteHouseModels, null)));
    });

    test('fetch', () async {
      var (result, err) = await houseRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
    });

    test('fetch local only', () async {
      var (result, err) = await houseRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, localHouseModels.length);
      verify(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);
      verifyNever(
          () => mockHouseRemoteDataSource.fetch(date: any(named: 'date')));

      for (int i = 0; i != localHouseModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(localHouseModels[i].date!);
        bool wattsEqual = result[i].watts == localHouseModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('fetch remote only', () async {
      when(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockHouseLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await houseRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteHouseModels.length);

      verify(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockHouseRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      for (int i = 0; i != remoteHouseModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(remoteHouseModels[i].date!);
        bool wattsEqual = result[i].watts == remoteHouseModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('Caching after remote fetch', () async {
      when(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockHouseLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await houseRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteHouseModels.length);

      verify(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockHouseRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockHouseLocalDataSource.create(any()))
          .called(remoteHouseModels.length);
    });

    test('Remote fetch fails', () async {
      when(() => mockHouseLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockHouseRemoteDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value(
              (null, SolaraIOException(type: IOExceptionType.other))));

      var (result, err) = await houseRepoImpl.fetch(date: DateTime.now());

      expect(result, isNotNull);
      expect(result!.isEmpty, true);
      expect(err is SolaraIOException, true);
    });
  });
}
