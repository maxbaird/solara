import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../domain/usecases/house_usecase.dart';
import '../model/house_ui_model.dart';

part 'house_event.dart';
part 'house_state.dart';

final DateTime _date = DateTime.now();

/// A time resolution that stops at day is sufficient. Going into the
/// milliseconds makes testing tedious.
///
/// There might be a more idiomatic way to achieve this, but this is the most
/// straightforward way that avoids an additional dependency on a package such
/// as intl.
final DateTime _currentDate = DateTime(_date.year, _date.month, _date.day);

/// The bloc for managing the state of house tab on the UI.
class HouseBloc extends Bloc<HouseEvent, HouseState> {
  HouseBloc({required this.fetchHouseUseCase})
      : super(
          HouseInitial(
            houseUiModel: HouseUiModel(
              date: _currentDate,
              unitType: SolaraUnitType.watts,
              plotData: <double, double>{},
            ),
            blocStatus: SolaraBlocStatus.initial,
          ),
        ) {
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

    /// Build a Ui model from results.
    final HouseUiModel houseUiModel = HouseUiModel.fromEntityList(
      houseEntities: houseEntities,
      date: event.date,
      unitType: state.houseUiModel.unitType, // preserve the current unit type
    );

    /// Emit a success state.
    emit(
      state.copyWith(
        houseUiModel: houseUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }

  void _onToggleWatts(ToggleWatts event, Emitter<HouseState> emit) {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    final HouseUiModel houseUiModel = state.houseUiModel.copyWith(
      unitType:
          event.showKilowatt ? SolaraUnitType.kilowatts : SolaraUnitType.watts,
    );

    emit(
      state.copyWith(
        houseUiModel: houseUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }
}
