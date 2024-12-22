import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';

/// A widget to display a line chart.
class SolaraGraph extends StatelessWidget {
  /// Creates a widget that displays a line chart.
  ///
  /// Line chart is created from [plotData].
  const SolaraGraph({
    super.key,
    required this.plotData,
    this.xLabel = 'Time of Day',
    this.yLabel = 'Watts',
    this.unitType = SolaraUnitType.watts,
  });

  /// {@template solara.widgets.solarGraph.plotData}
  /// The data used to plot the line chart.
  /// {@endtemplate}
  final SolaraPlotData plotData;

  /// {@template solara.widgets.solarGraph.xLabel}
  /// The title for the x-axis.
  /// {@endtemplate}
  final String xLabel;

  /// {@template solara.widgets.solarGraph.yLabel}
  /// The title for the y-axis.
  /// {@endtemplate}
  final String yLabel;

  /// {@template solara.widgets.solarGraph.unitType}
  /// The type of units used for the y-axis tics.
  /// {@endtemplate}
  final SolaraUnitType unitType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: _LineChart(
            key: const Key('_solaraLineChart'),
            yLabel: yLabel,
            xLabel: xLabel,
            unitType: unitType,
            plotData: plotData,
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a line chart.
class _LineChart extends StatelessWidget {
  const _LineChart({
    super.key,
    required this.xLabel,
    required this.yLabel,
    required this.unitType,
    required this.plotData,
  });

  /// {@macro solara.widgets.solarGraph.plotData}
  final SolaraPlotData plotData;

  /// {@macro solara.widgets.solarGraph.xLabel}
  final String xLabel;

  /// {@macro solara.widgets.solarGraph.yLabel}
  final String yLabel;

  /// {@macro solara.widgets.solarGraph.unitType}
  final SolaraUnitType unitType;

  /// Converts [plotData] into a list of [FlSpot] needed by [LineChart].
  List<FlSpot> get _flSpots =>
      plotData.entries.map((entry) => FlSpot(entry.key, entry.value)).toList();

  /// {@template solara.widgets._lineChart._itemCount}
  /// A count of how many data points to plot.
  /// {@endtemplate}
  int get _itemCount => plotData.length;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: _YAxisTitle(
            label: yLabel,
            unitType: unitType,
          ).title,
          bottomTitles: _XAxisTitle(
            label: xLabel,
            itemCount: _itemCount,
          ).title,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _flSpots,
          )
        ],
      ),
    );
  }
}

/// Holds the display configuration for the y-axis title and tics.
class _YAxisTitle {
  const _YAxisTitle({
    required this.label,
    required this.unitType,
  });

  /// The label for the axis.
  final String label;

  /// What unit type should be used for the tics.
  final SolaraUnitType unitType;

  /// Returns the divisor to use when converting tics between watts and
  /// kilowatts.
  int get _divisor => switch (unitType) {
        SolaraUnitType.watts => 1,
        SolaraUnitType.kilowatts => 1000,
      };

  /// Gets the formatting for the axis title and tics.
  AxisTitles get title => AxisTitles(
        axisNameSize: 24.0,
        axisNameWidget: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        sideTitles: SideTitles(
          reservedSize: 42,
          showTitles: true,
          getTitlesWidget: (value, _) {
            return Text((value / _divisor).toInt().toString() + unitType.unit);
          },
        ),
      );
}

/// Holds the display configuration for the x-axis title and tics.
class _XAxisTitle {
  const _XAxisTitle({
    required this.label,
    required this.itemCount,
  });

  /// The label for the axis.
  final String label;

  /// {@macro solara.widgets._lineChart._itemCount}
  final int itemCount;

  /// Prefixes a widget with a 0 if it is a single digit.
  String _padDigit(int digit) {
    return digit.toString().length == 1 ? '0$digit' : digit.toString();
  }

  /// Returns the title and tic configuration for the axis.
  AxisTitles get title => AxisTitles(
        axisNameWidget: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        axisNameSize: 24.0,
        sideTitles: SideTitles(
          getTitlesWidget: (value, meta) {
            // Avoids overlapping labels at start and end of axis.
            if (value == meta.max) {
              return const Text('');
            } else if (value == meta.min) {
              return const Text('');
            }

            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(value.toInt());
            // Return rotated tics to avoid overlapping
            return Transform.rotate(
              angle: -math.pi / 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child:
                    Text('${_padDigit(date.hour)}:${_padDigit(date.minute)}'),
              ),
            );
          },
          reservedSize: 40,
          showTitles: true,
          interval: (itemCount * Duration.millisecondsPerMinute).toDouble(),
        ),
      );
}
