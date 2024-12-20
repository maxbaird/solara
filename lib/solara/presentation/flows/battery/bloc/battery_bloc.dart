import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/params/fetch_params.dart';
import '../../../../domain/usecases/battery_usecase.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';

part 'battery_event.dart';
part 'battery_state.dart';

class BatteryBloc extends Bloc<BatteryEvent, BatteryState> {
  BatteryBloc({required this.fetchBatteryUseCase})
      : super(BatteryInitial(
          date: DateTime.now(),
          unitType: SolaraUnitType.watts,
          plotData: {},
          blocStatus: SolaraBlocStatus.initial,
        )) {
    on<Fetch>(_onFetch);
    on<ToggleWatts>(_onToggleWatts);
  }

  final FetchBatteryUseCase fetchBatteryUseCase;

  Future<void> _onFetch(Fetch event, Emitter<BatteryState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (houseEntities, err) =
        await fetchBatteryUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (houseEntities == null || houseEntities.isEmpty) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.noData));
      return;
    }

    /// Filter away null dates and keep dates that exactly match [event.date]
    houseEntities = houseEntities.where((e) {
      final DateTime? d = e.date;
      if (d != null) {
        return d.year == event.date.year &&
            d.month == event.date.month &&
            d.day == event.date.day;
      }
      return false;
    }).toList();

    SolaraPlotData plotData = {};

    for (var houseEntity in houseEntities) {
      double? date = houseEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = houseEntity.watts?.toDouble();

      if (date != null && watts != null) {
        plotData[date] = watts;
      }
    }

    emit(
      state.copyWith(
        plotData: plotData,
        date: event.date,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }

  void _onToggleWatts(ToggleWatts event, Emitter<BatteryState> emit) {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));
    emit(
      state.copyWith(
        unitType: event.showKilowatt
            ? SolaraUnitType.kilowatts
            : SolaraUnitType.watts,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }
}
