import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/params/fetch_params.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../domain/entities/house.dart';
import '../../../../domain/usecases/house_usecase.dart';

part 'home_event.dart';
part 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  HouseBloc({required this.fetchHouseUseCase})
      : super(HouseInitial(
          date: DateTime.now(),
          unitType: SolaraUnitType.watts,
          houseEntities: [],
          blocStatus: SolaraBlocStatus.initial,
        )) {
    on<Fetch>(_onFetch);
  }

  final FetchHouseUseCase fetchHouseUseCase;

  Future<void> _onFetch(Fetch event, Emitter<HouseState> emit) async {
    emit(state.copyWith(blocStatus: SolaraBlocStatus.inProgress));

    var (result, err) =
        await fetchHouseUseCase.call(params: FetchParams(date: event.date));

    if (err != null) {
      emit(state.copyWith(blocStatus: SolaraBlocStatus.failure));
    } else {
      emit(state.copyWith(
        houseEntities: result,
        blocStatus: SolaraBlocStatus.success,
      ));
      print(state.houseEntities);
    }
  }
}
