import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../domain/usecases/solar_usecase.dart';
import '../model/solar_ui_model.dart';

part 'solar_event.dart';
part 'solar_state.dart';

final DateTime _date = DateTime.now();

/// A time resolution that stops at day is sufficient. Going into the
/// milliseconds makes testing tedious.
///
/// There might be a more idiomatic way to achieve this, but this is the most
/// straightforward way that avoids an additional dependency on a package such
/// as intl.
final DateTime _currentDate = DateTime(_date.year, _date.month, _date.day);

/// A utility method to quickly create a new instance of an existing state.
class SolarBloc extends Bloc<SolarEvent, SolarState> {
  SolarBloc({required this.fetchSolarUseCase})
      : super(
          SolarInitial(
            solarUiModel: SolarUiModel(
              date: _currentDate,
              unitType: SolaraUnitType.watts,
              plotData: <double, double>{},
            ),
            blocStatus: SolaraBlocStatus.initial,
          ),
        ) {
    /// A utility method to quickly create a new instance of an existing state.
    on<Fetch>(_onFetch);

    /// Register a method to toggle the wattage units.
    on<ToggleWatts>(_onToggleWatts);
  }

  /// The use case to invoke to fetch chart data.
  final FetchSolarUseCase fetchSolarUseCase;

  Future<void> _onFetch(Fetch event, Emitter<SolarState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (solarEntities, err) =
        await fetchSolarUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      /// Error when fetching.
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
      return;
    }

    if (solarEntities == null || solarEntities.isEmpty) {
      /// Found no data.
      emit(state.copyWith(blocStatus: SolaraBlocStatus.noData));
      return;
    }

    /// Build a Ui model from results.
    final SolarUiModel solarUiModel = SolarUiModel.fromEntityList(
      solarEntities: solarEntities,
      date: event.date,
    );

    /// Emit a success state.
    emit(
      state.copyWith(
        solarUiModel: solarUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }

  void _onToggleWatts(ToggleWatts event, Emitter<SolarState> emit) {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    final SolarUiModel solarUiModel = state.solarUiModel.copyWith(
      unitType:
          event.showKilowatt ? SolaraUnitType.kilowatts : SolaraUnitType.watts,
    );

    emit(
      state.copyWith(
        solarUiModel: solarUiModel,
        blocStatus: SolaraBlocStatus.success,
      ),
    );
  }
}
