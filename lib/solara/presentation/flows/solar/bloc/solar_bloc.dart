import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/usecases/solar_usecase.dart';

part 'solar_event.dart';
part 'solar_state.dart';

class SolarBloc extends Bloc<SolarEvent, SolarState> {
  SolarBloc({required this.fetchSolarUseCase})
      : super(SolarInitial(
          date: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          unitType: SolaraUnitType.watts,
          plotData: {},
          blocStatus: SolaraBlocStatus.initial,
        )) {
    on<Fetch>(_onFetch);
    on<ToggleWatts>(_onToggleWatts);
  }

  final FetchSolarUseCase fetchSolarUseCase;

  Future<void> _onFetch(Fetch event, Emitter<SolarState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (solarEntities, err) =
        await fetchSolarUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (solarEntities == null || solarEntities.isEmpty) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.noData));
      return;
    }

    /// Filter away null dates and keep dates that exactly match [event.date]
    solarEntities = solarEntities.where((e) {
      final DateTime? d = e.date;
      if (d != null) {
        return d.year == event.date.year &&
            d.month == event.date.month &&
            d.day == event.date.day;
      }
      return false;
    }).toList();

    SolaraPlotData plotData = {};

    for (var solarEntity in solarEntities) {
      double? date = solarEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = solarEntity.watts?.toDouble();

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

  void _onToggleWatts(ToggleWatts event, Emitter<SolarState> emit) {
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
