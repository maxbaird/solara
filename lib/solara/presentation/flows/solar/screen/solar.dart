import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/widgets/solara_circular_progress_indicator.dart';
import '../../../../../core/presentation/widgets/solara_data_visualizer.dart';
import '../../../../../core/presentation/widgets/solara_information_message.dart';
import '../bloc/solar_bloc.dart';

class Solar extends StatefulWidget {
  const Solar({super.key});

  @override
  State<Solar> createState() => _SolarState();
}

class _SolarState extends State<Solar>
    with AutomaticKeepAliveClientMixin<Solar> {
  void _onToggleUnit(bool showKilowatt, BuildContext context) {
    context.read<SolarBloc>().add(ToggleWatts(showKilowatt: showKilowatt));
  }

  void _onDateChange(DateTime date, BuildContext context) {
    context.read<SolarBloc>().add(Fetch(date: date));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SolarBloc, SolarState>(
      builder: (context, state) {
        return switch (state.blocStatus) {
          SolaraBlocStatus.initial => const SolaraCircularProgressIndicator(),
          SolaraBlocStatus.inProgress =>
            const SolaraCircularProgressIndicator(),
          SolaraBlocStatus.success => SolaraDataVisualizer(
              uiModel: state.solarUiModel,
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
