import 'package:flutter/material.dart';

import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';
import 'solara_line_chart.dart';
import 'util/solara_date_picker.dart';

/// A widget that displays graphs.
///
/// This widget also provides options to toggle the graph's unit type and to
/// select for what date data should be requested.
class SolaraDataVisualizer extends StatelessWidget {
  /// Creates a widget to display graphs.
  ///
  /// Unit type and date can be selected.
  const SolaraDataVisualizer({
    super.key,
    required this.date,
    required this.plotData,
    required this.unitType,
    required this.onToggleUnit,
    required this.onDateChange,
  });

  /// {@template solara.widgets.solaraDataVisualizer.date}
  /// The date for the data currently being displayed.
  /// {@endtemplate}
  final DateTime date;

  /// The raw data used to plot the line graph.
  final SolaraPlotData plotData;

  /// {@template solara.widgets.solaraDataVisualizer.unitType}
  /// What units should be used for the graph's watt data.
  /// {@endtemplate}
  final SolaraUnitType unitType;

  /// {@template solara.widgets.solaraDataVisualizer.onToggleUnit}
  /// A callback for when the user toggles the graph's units.
  /// {@endtemplate}
  final void Function(bool) onToggleUnit;

  /// {@template solara.widgets.solaraDataVisualizer.onDateChange}
  /// A callback for when the user changes the currently selected date.
  /// {@endtemplate}
  final void Function(DateTime) onDateChange;

  /// Returns a formatted date to be used as the x-axis label.
  String get _date => '${date.year}/${date.month}/${date.day}';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SolaraLineChart(
          key: Key('solaraGraph'),
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

/// A widget positioned below [SolaraDataVisualizer].
///
/// Displays the option to toggle the units and select a new date.
class _BottomRow extends StatelessWidget {
  const _BottomRow({
    super.key,
    required this.unitType,
    required this.currentlySelectedDate,
    required this.onToggleUnit,
    required this.onDateChange,
  });

  /// {@macro solara.widgets.solaraDataVisualizer.unitType}
  final SolaraUnitType unitType;

  /// {@macro solara.widgets.solaraDataVisualizer.date}
  final DateTime currentlySelectedDate;

  /// {@macro solara.widgets.solaraDataVisualizer.onToggleUnit}
  final void Function(bool) onToggleUnit;

  /// {@macro solara.widgets.solaraDataVisualizer.onDateChange}
  final void Function(DateTime) onDateChange;

  /// Whether to display y-axis data in watts or kilowatts.
  bool get _showKilowatt => switch (unitType) {
        SolaraUnitType.kilowatts => true,
        SolaraUnitType.watts => false,
      };

  /// Displays a date picker and invokes [onDateChange] with the selected date.
  ///
  /// If user cancels date selection then [onDateChange] is not invoked.
  Future<void> _onDateChange(BuildContext context) async {
    DateTime? date = await solaraDatePicker(
      context: context,
      initialDate: currentlySelectedDate,
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
              key: const Key('solaraToggleUnit'),
              value: _showKilowatt,
              onChanged: onToggleUnit,
            ),
            const Text('Toggle Wattage Unit'),
          ],
        ),
        ElevatedButton(
          key: const Key('solaraDateSelect'),
          onPressed: () => _onDateChange(context),
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
