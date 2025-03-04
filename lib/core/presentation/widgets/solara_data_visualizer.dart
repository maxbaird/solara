import 'package:flutter/material.dart';
import 'package:solara/core/presentation/model/ui_model.dart';

import '../util/flows/bloc/solara_unit_type.dart';
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
    required this.onToggleUnit,
    required this.onDateChange,
    required this.uiModel,
  });

  /// The UI model that contains the data needed to render the line chart.
  final UiModel uiModel;

  /// {@template solara.widgets.solaraDataVisualizer.onToggleUnit}
  /// A callback for when the user toggles the graph's units.
  /// {@endtemplate}
  final void Function(bool) onToggleUnit;

  /// {@template solara.widgets.solaraDataVisualizer.onDateChange}
  /// A callback for when the user changes the currently selected date.
  /// {@endtemplate}
  final void Function(DateTime) onDateChange;

  /// Returns a formatted date to be used as the x-axis label.
  String get _date =>
      '${uiModel.date.year}/${uiModel.date.month}/${uiModel.date.day}';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SolaraLineChart(
          key: Key('solaraGraph'),
          xLabel: _date,
          plotData: uiModel.plotData,
          unitType: uiModel.unitType,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _BottomRow(
            key: const Key('solaraBottomRow'),
            currentlySelectedDate: uiModel.date,
            unitType: uiModel.unitType,
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

  /// What units should be used for the graph's watt data.
  final SolaraUnitType unitType;

  /// The date for the data currently being displayed.
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
