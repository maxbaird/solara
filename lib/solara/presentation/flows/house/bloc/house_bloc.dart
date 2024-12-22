import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/usecases/house_usecase.dart';

part 'house_event.dart';
part 'house_state.dart';

/// The bloc for managing the state of house tab on the UI.
class HouseBloc extends Bloc<HouseEvent, HouseState> {
  HouseBloc({required this.fetchHouseUseCase})
      : super(HouseInitial(
          date: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          unitType: SolaraUnitType.watts,
          plotData: {},
          blocStatus: SolaraBlocStatus.initial,
        )) {
    /// Register a method to fetch chart data.
    on<Fetch>(_onFetch);

    /// Register a method to toggle the wattage units.
    on<ToggleWatts>(_onToggleWatts);
  }

  /// The use case to invoke to fetch chart data.
  final FetchHouseUseCase fetchHouseUseCase;

  Future<void> _onFetch(Fetch event, Emitter<HouseState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (houseEntities, err) =
        await fetchHouseUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      /// Error when fetching.
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (houseEntities == null || houseEntities.isEmpty) {
      /// Found no data.
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

    /// Populate [plotData] with data from filtered [houseEntities].
    for (var houseEntity in houseEntities) {
      double? date = houseEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = houseEntity.watts?.toDouble();

      if (date != null && watts != null) {
        plotData[date] = watts;
      }
    }

    /// Emit a success state.
    emit(
      state.copyWith(
        plotData: plotData,
        date: event.date,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }

  void _onToggleWatts(ToggleWatts event, Emitter<HouseState> emit) {
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
