import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/usecases/house_usecase.dart';

part 'house_event.dart';
part 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  HouseBloc({required this.fetchHouseUseCase})
      : super(HouseInitial(
          date: DateTime.now(),
          unitType: SolaraUnitType.watts,
          plotData: {},
          blocStatus: SolaraBlocStatus.initial,
        )) {
    on<Fetch>(_onFetch);
    on<ToggleWatts>(_onToggleWatts);
  }

  final FetchHouseUseCase fetchHouseUseCase;

  Future<void> _onFetch(Fetch event, Emitter<HouseState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (houseEntities, err) =
        await fetchHouseUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (houseEntities == null || houseEntities.isEmpty) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.noData));
      return;
    }

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

  void _onToggleWatts(ToggleWatts event, Emitter<HouseState> emit) {
    emit(
      state.copyWith(
        unitType: event.showKilowatt
            ? SolaraUnitType.kilowatts
            : SolaraUnitType.watts,
      ),
    );
  }
}
