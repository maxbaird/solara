import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/params/fetch_params.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_bloc_status.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_unit_type.dart';
import 'package:solara/core/presentation/util/flows/solara_plot_data.dart';
import 'package:solara/solara/domain/entities/battery.dart';
import 'package:solara/solara/domain/usecases/battery_usecase.dart';
import 'package:solara/solara/presentation/flows/battery/bloc/battery_bloc.dart';

class MockFetchBatteryUseCase extends Mock implements FetchBatteryUseCase {}

void main() {
  final mockFetchBatteryUseCase = MockFetchBatteryUseCase();

  BatteryBloc build() => BatteryBloc(
        fetchBatteryUseCase: mockFetchBatteryUseCase,
      );

  final date = DateTime(2024, 12, 22);

  final List<BatteryEntity> batteryEntities = [
    BatteryEntity(date: date, watts: 1000),
    BatteryEntity(date: date, watts: 2000),
    BatteryEntity(date: date, watts: 3000),
    BatteryEntity(date: DateTime(2024, 12, 22), watts: 4000),
  ];

  final SolaraPlotData plotData = {
    date.microsecondsSinceEpoch.toDouble(): 1000,
    date.microsecondsSinceEpoch.toDouble(): 2000,
    date.microsecondsSinceEpoch.toDouble(): 3000,
  };

  setUpAll(() {
    registerFallbackValue(FetchParams());
  });

  group('BatteryBloc', () {
    dynamic act(BatteryBloc bloc) => bloc.add(Fetch(date: date));

    blocTest(
      'Fetches battery entities',
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
    );
  });
}
