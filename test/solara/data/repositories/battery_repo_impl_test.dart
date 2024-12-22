import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/solara/data/datasources/battery_local_datasource.dart';
import 'package:solara/solara/data/datasources/battery_remote_datasource.dart';
import 'package:solara/solara/data/models/battery_model.dart';
import 'package:solara/solara/data/repositories/battery_repo_impl.dart';

class MockBatteryRemoteDataSource extends Mock
    implements BatteryRemoteDataSource {}

class MockBatteryLocalDataSource extends Mock
    implements BatteryLocalDataSource {}

void main() {
  final mockBatteryRemoteDataSource = MockBatteryRemoteDataSource();
  final mockBatteryLocalDataSource = MockBatteryLocalDataSource();
  final batteryRepoImpl =
      BatteryRepoImpl(mockBatteryRemoteDataSource, mockBatteryLocalDataSource);

  final List<BatteryModel> localBatteryModels = [
    BatteryModel(date: DateTime.now(), watts: 1000),
    BatteryModel(date: DateTime.now(), watts: 2000),
    BatteryModel(date: DateTime.now(), watts: 3000),
  ];

  final List<BatteryModel> remoteBatteryModels = [
    BatteryModel(date: DateTime.now(), watts: 1000),
    BatteryModel(date: DateTime.now(), watts: 2000),
    BatteryModel(date: DateTime.now(), watts: 3000),
  ];

  setUpAll(() {
    registerFallbackValue(BatteryModel());
  });

  group('BatteryRepoImpl', () {
    setUp(() {
      reset(mockBatteryRemoteDataSource);
      reset(mockBatteryLocalDataSource);
      when(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((localBatteryModels, null)));

      when(() => mockBatteryRemoteDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((remoteBatteryModels, null)));
    });

    test('fetch', () async {
      var (result, err) = await batteryRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
    });

    test('fetch local only', () async {
      var (result, err) = await batteryRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, localBatteryModels.length);
      verify(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);
      verifyNever(
          () => mockBatteryRemoteDataSource.fetch(date: any(named: 'date')));

      for (int i = 0; i != localBatteryModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(localBatteryModels[i].date!);
        bool wattsEqual = result[i].watts == localBatteryModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('fetch remote only', () async {
      when(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockBatteryLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await batteryRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteBatteryModels.length);

      verify(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockBatteryRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      for (int i = 0; i != remoteBatteryModels.length; ++i) {
        bool dateEqual =
            result[i].date!.isAtSameMomentAs(remoteBatteryModels[i].date!);
        bool wattsEqual = result[i].watts == remoteBatteryModels[i].watts!;
        expect(dateEqual && wattsEqual, true);
      }
    });

    test('Caching after remote fetch', () async {
      when(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .thenAnswer((_) => Future.value((null, null)));

      when(() => mockBatteryLocalDataSource.create(any()))
          .thenAnswer((_) => Future.value(true));

      var (result, err) = await batteryRepoImpl.fetch(date: DateTime.now());
      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, remoteBatteryModels.length);

      verify(() => mockBatteryLocalDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockBatteryRemoteDataSource.fetch(date: any(named: 'date')))
          .called(1);

      verify(() => mockBatteryLocalDataSource.create(any()))
          .called(remoteBatteryModels.length);
    });
  });
}
