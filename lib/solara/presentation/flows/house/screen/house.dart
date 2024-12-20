import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../../core/presentation/widgets/solara_circular_progress_indicator.dart';
import '../../../../../core/presentation/widgets/solara_error.dart';
import '../../../../../core/presentation/widgets/solara_line_chart.dart';
import '../../../../../injection_container.dart';
import '../bloc/house_bloc.dart';

class House extends StatelessWidget {
  const House({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HouseBloc>(
      create: (context) => sl()..add(Fetch(date: DateTime.now())),
      child: BlocBuilder<HouseBloc, HouseState>(
        builder: (context, state) {
          return switch (state.blocStatus) {
            SolaraBlocStatus.initial => const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.inProgress =>
              const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.success => SolaraDataVisualizer(
                date: state.date,
                plotData: state.plotData,
                unitType: state.unitType,
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

class SolaraDataVisualizer extends StatelessWidget {
  const SolaraDataVisualizer({
    super.key,
    required this.date,
    required this.plotData,
    required this.unitType,
  });

  final DateTime date;
  final SolaraPlotData plotData;
  final SolaraUnitType unitType;

  String get _date => '${date.year}/${date.month}/${date.day}';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SolaraGraph(
          xLabel: _date,
          plotData: plotData,
          unitType: unitType,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
              _BottomRow(key: const Key('solaraBottomRow'), unitType: unitType),
        ),
      ],
    );
  }
}

class _BottomRow extends StatelessWidget {
  const _BottomRow({
    super.key,
    required this.unitType,
  });

  final SolaraUnitType unitType;

  bool get _showKilowatt => switch (unitType) {
        SolaraUnitType.kilowatts => true,
        SolaraUnitType.watts => false,
      };

  void _onToggleUnit(bool showKilowatt, BuildContext context) {
    context.read<HouseBloc>().add(ToggleWatts(showKilowatt: showKilowatt));
  }

  void _onDateChange(BuildContext context) {
    context.read<HouseBloc>().add(
          Fetch(
            date: DateTime(2023, 03, 10),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Switch(
              value: _showKilowatt,
              onChanged: (showKilowatt) => _onToggleUnit(showKilowatt, context),
            ),
            const Text('Toggle Wattage Unit'),
          ],
        ),
        ElevatedButton(
          onPressed: () => _onDateChange(context),
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
