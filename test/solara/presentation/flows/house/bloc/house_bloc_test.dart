import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/params/fetch_params.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_bloc_status.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_unit_type.dart';
import 'package:solara/core/presentation/util/flows/solara_plot_data.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/solara/domain/entities/house.dart';
import 'package:solara/solara/domain/usecases/house_usecase.dart';
import 'package:solara/solara/presentation/flows/house/bloc/house_bloc.dart';
import 'package:solara/solara/presentation/flows/house/model/house_ui_model.dart';

class MockFetchHouseUseCase extends Mock implements FetchHouseUseCase {}

void main() {
  final mockFetchHouseUseCase = MockFetchHouseUseCase();

  HouseBloc build() => HouseBloc(
        fetchHouseUseCase: mockFetchHouseUseCase,
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

  final List<HouseEntity> houseEntities = [
    HouseEntity(date: date1, watts: 1000),
    HouseEntity(date: date2, watts: 2000),
    HouseEntity(date: date3, watts: 3000),
    HouseEntity(date: DateTime(1970, 12, 22, 0), watts: 4000),
  ];

  final SolaraPlotData plotData = {
    date1.microsecondsSinceEpoch.toDouble(): 1000,
    date2.microsecondsSinceEpoch.toDouble(): 2000,
    date3.microsecondsSinceEpoch.toDouble(): 3000,
  };

  setUpAll(() {
    registerFallbackValue(FetchParams());
  });

  group('HouseBloc: fetch', () {
    dynamic act(HouseBloc bloc) => bloc.add(Fetch(date: date));

    final DateTime currentDate = DateTime(date.year, date.month, date.day);

    final uiModel = HouseUiModel(
      date: currentDate,
      unitType: SolaraUnitType.watts,
      plotData: <double, double>{},
    );

    blocTest('Fetches house entities',
        build: build,
        setUp: () {
          when(() => mockFetchHouseUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (houseEntities, null));
        },
        act: act,
        expect: () => <HouseState>[
              HouseState(
                houseUiModel: uiModel,
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              HouseState(
                houseUiModel: uiModel,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.houseUiModel.plotData.length, plotData.length);

          // Compare values; there is a loss of precision when comparing the dates
          // after being converted to milliseconds.
          for (int i = 0; i != plotData.length; ++i) {
            expect(
                bloc.state.houseUiModel.plotData.values.elementAt(i) ==
                    plotData.values.elementAt(i),
                true);
          }
        });

    blocTest('Filters house entities outside of specified date',
        build: build,
        setUp: () {
          when(() => mockFetchHouseUseCase.call(params: any(named: 'params')))
              .thenAnswer((_) async => (houseEntities, null));
        },
        act: act,
        expect: () => <HouseState>[
              HouseState(
                houseUiModel: uiModel,
                blocStatus: SolaraBlocStatus.inProgress,
              ),
              HouseState(
                houseUiModel: uiModel,
                blocStatus: SolaraBlocStatus.success,
              ),
            ],
        verify: (bloc) {
          expect(bloc.state.houseUiModel.plotData.length,
              houseEntities.length - 1);

          // Compare values; there is a loss of precision when comparing the dates
          // after being converted to milliseconds.
          for (int i = 0; i != plotData.length; ++i) {
            expect(
                bloc.state.houseUiModel.plotData.values.elementAt(i) ==
                    plotData.values.elementAt(i),
                true);
          }
        });

    blocTest(
      'Emits failure if usecase returns error',
      build: build,
      setUp: () {
        when(() => mockFetchHouseUseCase.call(params: any(named: 'params')))
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
        when(() => mockFetchHouseUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => (<HouseEntity>[], null));
      },
      act: act,
      verify: (bloc) =>
          expect(bloc.state.blocStatus == SolaraBlocStatus.noData, true),
    );
  });

  group('HouseBloc: ToggleWatts', () {
    // dynamic act(HouseBloc bloc) => bloc.add(ToggleWatts(showKilowatt: true));

    blocTest(
      'Toggles kilowatts on',
      build: build,
      act: (bloc) => bloc.add(ToggleWatts(showKilowatt: true)),
      verify: (bloc) => expect(
          bloc.state.houseUiModel.unitType == SolaraUnitType.kilowatts, true),
    );

    blocTest(
      'Toggles kilowatts off',
      build: build,
      act: (bloc) => bloc.add(ToggleWatts(showKilowatt: false)),
      verify: (bloc) => expect(
          bloc.state.houseUiModel.unitType == SolaraUnitType.watts, true),
    );
  });
}
