import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/widgets/solara_circular_progress_indicator.dart';
import '../../../../../core/presentation/widgets/solara_data_visualizer.dart';
import '../../../../../core/presentation/widgets/solara_information_message.dart';
import '../bloc/house_bloc.dart';

class House extends StatefulWidget {
  const House({super.key});

  @override
  State<House> createState() => _HouseState();
}

class _HouseState extends State<House>
    with AutomaticKeepAliveClientMixin<House> {
  void _onToggleUnit(bool showKilowatt, BuildContext context) {
    context.read<HouseBloc>().add(ToggleWatts(showKilowatt: showKilowatt));
  }

  void _onDateChange(DateTime date, BuildContext context) {
    context.read<HouseBloc>().add(Fetch(date: date));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HouseBloc, HouseState>(
      builder: (context, state) {
        return switch (state.blocStatus) {
          SolaraBlocStatus.initial => const SolaraCircularProgressIndicator(),
          SolaraBlocStatus.inProgress =>
            const SolaraCircularProgressIndicator(),
          SolaraBlocStatus.success => SolaraDataVisualizer(
              uiModel: state.houseUiModel,
              onToggleUnit: (showKilowatt) => _onToggleUnit(
                showKilowatt,
                context,
              ),
              onDateChange: (date) => _onDateChange(
                date,
                context,
              ),
            ),
          SolaraBlocStatus.failure => SolaraInformationMessage(
              message: 'Failed to load data',
              onSelectDate: (date) => _onDateChange(
                date,
                context,
              ),
            ),
          SolaraBlocStatus.noData => SolaraInformationMessage(
              message: 'No data for for selected date',
              onSelectDate: (date) => _onDateChange(
                date,
                context,
              ),
            ),
        };
      },
    );
  }
}
