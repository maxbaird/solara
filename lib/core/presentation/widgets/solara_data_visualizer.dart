import 'package:flutter/material.dart';

import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';
import 'solara_line_chart.dart';

class SolaraDataVisualizer extends StatelessWidget {
  const SolaraDataVisualizer({
    super.key,
    required this.date,
    required this.plotData,
    required this.unitType,
    required this.onToggleUnit,
    required this.onDateChange,
  });

  final DateTime date;
  final SolaraPlotData plotData;
  final SolaraUnitType unitType;
  final void Function(bool) onToggleUnit;
  final void Function(DateTime) onDateChange;

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
          child: _BottomRow(
            key: const Key('solaraBottomRow'),
            currentlySelectedDate: date,
            unitType: unitType,
            onDateChange: onDateChange,
            onToggleUnit: onToggleUnit,
          ),
        ),
      ],
    );
  }
}

class _BottomRow extends StatelessWidget {
  const _BottomRow({
    super.key,
    required this.unitType,
    required this.currentlySelectedDate,
    required this.onToggleUnit,
    required this.onDateChange,
  });

  final SolaraUnitType unitType;
  final DateTime currentlySelectedDate;
  final void Function(bool) onToggleUnit;
  final void Function(DateTime) onDateChange;

  bool get _showKilowatt => switch (unitType) {
        SolaraUnitType.kilowatts => true,
        SolaraUnitType.watts => false,
      };

  Future<void> _onDateChange(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: currentlySelectedDate,
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );
    if (!context.mounted || date == null) {
      return;
    }
    onDateChange(date);
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
              onChanged: onToggleUnit,
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
