import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/params/fetch_params.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_bloc_status.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_unit_type.dart';
import 'package:solara/core/presentation/util/flows/solara_plot_data.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/domain/entities/solar.dart';
import 'package:solara/solara/domain/usecases/solar_usecase.dart';
import 'package:solara/solara/presentation/flows/solar/bloc/solar_bloc.dart';

class MockFetchSolarUseCase extends Mock implements FetchSolarUseCase {}

void main() {
  final mockFetchSolarUseCase = MockFetchSolarUseCase();

  SolarBloc build() => SolarBloc(
        fetchSolarUseCase: mockFetchSolarUseCase,
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

  final List<SolarEntity> solarEntities = [
    SolarEntity(date: date1, watts: 1000),
    SolarEntity(date: date2, watts: 2000),
    SolarEntity(date: date3, watts: 3000),
    SolarEntity(date: DateTime(1970, 12, 22, 0), watts: 4000),
  ];

  final SolaraPlotData plotData = {
    date1.microsecondsSinceEpoch.toDouble(): 1000,
    date2.microsecondsSinceEpoch.toDouble(): 2000,
    date3.microsecondsSinceEpoch.toDouble(): 3000,
  };

  setUpAll(() {
    registerFallbackValue(FetchParams());
  });

  group('SolarBloc: fetch', () {
    dynamic act(SolarBloc bloc) => bloc.add(Fetch(date: date));

    blocTest('Fetches solar entities',
        build: build,
        setUp: () {
          when(() => mockFetchSolarUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (solarEntities, null));
        },
        act: act,
        expect: () => <SolarState>[
              SolarState(
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                unitType: SolaraUnitType.watts,
                plotData: {},
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              SolarState(
                date: date,
                unitType: SolaraUnitType.watts,
                plotData: plotData,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.plotData.length, plotData.length);

          // Compare values; there is a loss of precision when comparing the dates
          // after being converted to milliseconds.
          for (int i = 0; i != plotData.length; ++i) {
            expect(
                bloc.state.plotData.values.elementAt(i) ==
                    plotData.values.elementAt(i),
                true);
          }
        });

    blocTest('Filters solar entities outside of specified date',
        build: build,
        setUp: () {
          when(() => mockFetchSolarUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (solarEntities, null));
        },
        act: act,
        expect: () => <SolarState>[
              SolarState(
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                unitType: SolaraUnitType.watts,
                plotData: {},
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              SolarState(
                date: date,
                unitType: SolaraUnitType.watts,
                plotData: plotData,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.plotData.length, solarEntities.length - 1);

          // Compare values; there is a loss of precision when comparing the dates
          // after being converted to milliseconds.
          for (int i = 0; i != plotData.length; ++i) {
            expect(
                bloc.state.plotData.values.elementAt(i) ==
                    plotData.values.elementAt(i),
                true);
          }
        });

    blocTest(
      'Emits failure if usecase returns error',
      build: build,
      setUp: () {
        when(() => mockFetchSolarUseCase.call(params: any(named: 'params')))
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
        when(() => mockFetchSolarUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => (<SolarEntity>[], null));
      },
      act: act,
      verify: (bloc) =>
          expect(bloc.state.blocStatus == SolaraBlocStatus.noData, true),
    );
  });

  group('SolarBloc: ToggleWatts', () {
    // dynamic act(SolarBloc bloc) => bloc.add(ToggleWatts(showKilowatt: true));

    blocTest(
      'Toggles kilowatts on',
      build: build,
      act: (bloc) => bloc.add(ToggleWatts(showKilowatt: true)),
      verify: (bloc) =>
          expect(bloc.state.unitType == SolaraUnitType.kilowatts, true),
    );

    blocTest(
      'Toggles kilowatts off',
      build: build,
      act: (bloc) => bloc.add(ToggleWatts(showKilowatt: false)),
      verify: (bloc) =>
          expect(bloc.state.unitType == SolaraUnitType.watts, true),
    );
  });
}
