import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/params/fetch_params.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_bloc_status.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_unit_type.dart';
import 'package:solara/core/presentation/util/flows/solara_plot_data.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/domain/entities/battery.dart';
import 'package:solara/solara/domain/usecases/battery_usecase.dart';
import 'package:solara/solara/presentation/flows/battery/bloc/battery_bloc.dart';

class MockFetchBatteryUseCase extends Mock implements FetchBatteryUseCase {}

void main() {
  final mockFetchBatteryUseCase = MockFetchBatteryUseCase();

  BatteryBloc build() => BatteryBloc(
        fetchBatteryUseCase: mockFetchBatteryUseCase,
      );

  final date = DateTime.now();
  final date1 = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
  );
  final date2 = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    1,
  );
  final date3 = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    2,
  );

  final List<BatteryEntity> batteryEntities = [
    BatteryEntity(date: date1, watts: 1000),
    BatteryEntity(date: date2, watts: 2000),
    BatteryEntity(date: date3, watts: 3000),
    BatteryEntity(date: DateTime(1970, 12, 22, 0), watts: 4000),
  ];

  final SolaraPlotData plotData = {
    date1.microsecondsSinceEpoch.toDouble(): 1000,
    date2.microsecondsSinceEpoch.toDouble(): 2000,
    date3.microsecondsSinceEpoch.toDouble(): 3000,
  };

  setUpAll(() {
    registerFallbackValue(FetchParams());
  });

  group('BatteryBloc: fetch', () {
    dynamic act(BatteryBloc bloc) => bloc.add(Fetch(date: date));

    blocTest('Fetches battery entities',
        build: build,
        setUp: () {
          when(() => mockFetchBatteryUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (batteryEntities, null));
        },
        act: act,
        expect: () => <BatteryState>[
              BatteryState(
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                unitType: SolaraUnitType.watts,
                plotData: {},
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              BatteryState(
                date: date,
                unitType: SolaraUnitType.watts,
                plotData: plotData,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.plotData.length, plotData.length);
        });

    blocTest('Filters battery entities outside of specified date',
        build: build,
        setUp: () {
          when(() => mockFetchBatteryUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (batteryEntities, null));
        },
        act: act,
        expect: () => <BatteryState>[
              BatteryState(
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                unitType: SolaraUnitType.watts,
                plotData: {},
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              BatteryState(
                date: date,
                unitType: SolaraUnitType.watts,
                plotData: plotData,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.plotData.length, batteryEntities.length - 1);
        });

    blocTest(
      'Emits failure if usecase returns error',
      build: build,
      setUp: () {
        when(() => mockFetchBatteryUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => (null, SolaraIOException()));
      },
      act: act,
      verify: (bloc) =>
          expect(bloc.state.blocStatus == SolaraBlocStatus.failure, true),
    );

    blocTest(
      'handles no results',
      build: build,
      setUp: () {
        when(() => mockFetchBatteryUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => (<BatteryEntity>[], null));
      },
      act: act,
      verify: (bloc) =>
          expect(bloc.state.blocStatus == SolaraBlocStatus.noData, true),
    );
  });
}
