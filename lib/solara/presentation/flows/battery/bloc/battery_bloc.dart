import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solara/solara/presentation/flows/battery/model/battery_ui_model.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/usecases/battery_usecase.dart';

part 'battery_event.dart';
part 'battery_state.dart';

final DateTime _date = DateTime.now();

/// A time resolution that stops at day is sufficient. Going into the
/// milliseconds makes testing tedious.
///
/// There might be a more idiomatic way to achieve this, but this is the most
/// straightforward way that avoids an additional dependency on a package such
/// as intl.
final DateTime _currentDate = DateTime(_date.year, _date.month, _date.day);

/// The bloc for managing the state of battery tab on the UI.
class BatteryBloc extends Bloc<BatteryEvent, BatteryState> {
  BatteryBloc({required this.fetchBatteryUseCase})
      : super(BatteryInitial(
          // date: DateTime(
          //   DateTime.now().year,
          //   DateTime.now().month,
          //   DateTime.now().day,
          // ),
          // unitType: SolaraUnitType.watts,
          // plotData: {},
          batteryUiModel: BatteryUiModel(
              date: _currentDate,
              unitType: SolaraUnitType.watts,
              plotData: <double, double>{}),
          blocStatus: SolaraBlocStatus.initial,
        )) {
    /// Register a method to fetch chart data.
    on<Fetch>(_onFetch);

    /// Register a method to toggle the wattage units.
    on<ToggleWatts>(_onToggleWatts);
  }

  /// The use case to invoke to fetch chart data.
  final FetchBatteryUseCase fetchBatteryUseCase;

  Future<void> _onFetch(Fetch event, Emitter<BatteryState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (batteryEntities, err) =
        await fetchBatteryUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      /// Error when fetching.
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (batteryEntities == null || batteryEntities.isEmpty) {
      /// Found no data.
      emit(state.copyWith(blocStatus: SolaraBlocStatus.noData));
      return;
    }

    /// Build a Ui model from results.
    final BatteryUiModel batteryUiModel = BatteryUiModel.fromEntityList(
      batteryEntities: batteryEntities,
      date: event.date,
    );

    /// Emit a success state.
    emit(
      state.copyWith(
        // plotData: {},
        // date: event.date,
        batteryUiModel: batteryUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }

  void _onToggleWatts(ToggleWatts event, Emitter<BatteryState> emit) {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    final BatteryUiModel batteryUiModel = state.batteryUiModel.copyWith(
      unitType:
          event.showKilowatt ? SolaraUnitType.kilowatts : SolaraUnitType.watts,
    );

    emit(
      state.copyWith(
        // unitType: event.showKilowatt
        //     ? SolaraUnitType.kilowatts
        //     : SolaraUnitType.watts,
        batteryUiModel: batteryUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }
}
