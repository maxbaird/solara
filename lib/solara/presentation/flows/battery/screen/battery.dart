import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/widgets/solara_circular_progress_indicator.dart';
import '../../../../../core/presentation/widgets/solara_data_visualizer.dart';
import '../../../../../core/presentation/widgets/solara_error.dart';
import '../../../../../injection_container.dart';
import '../bloc/battery_bloc.dart';

class Battery extends StatefulWidget {
  const Battery({super.key});

  @override
  State<Battery> createState() => _BatteryState();
}

class _BatteryState extends State<Battery>
    with AutomaticKeepAliveClientMixin<Battery> {
  void _onToggleUnit(bool showKilowatt, BuildContext context) {
    context.read<BatteryBloc>().add(ToggleWatts(showKilowatt: showKilowatt));
  }

  void _onDateChange(DateTime date, BuildContext context) {
    context.read<BatteryBloc>().add(Fetch(date: date));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<BatteryBloc>(
      create: (context) => sl()..add(Fetch(date: DateTime.now())),
      child: BlocBuilder<BatteryBloc, BatteryState>(
        builder: (context, state) {
          return switch (state.blocStatus) {
            SolaraBlocStatus.initial => const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.inProgress =>
              const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.success => SolaraDataVisualizer(
                date: state.date,
                plotData: state.plotData,
                unitType: state.unitType,
                onToggleUnit: (showKilowatt) => _onToggleUnit(
                  showKilowatt,
                  context,
                ),
                onDateChange: (date) => _onDateChange(
                  date,
                  context,
                ),
              ),
            SolaraBlocStatus.failure => const SolaraError(
                message: 'Failed to load data',
              ),
            SolaraBlocStatus.noData => const SolaraError(
                message: 'No data for for selected date',
              ),
          };
        },
      ),
    );
  }
}
