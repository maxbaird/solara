import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';

class SolaraGraph extends StatelessWidget {
  const SolaraGraph({
    super.key,
    required this.plotData,
    this.xLabel = 'Time of Day',
    this.yLabel = 'Watts',
    this.unitType = SolaraUnitType.watts,
  });

  final SolaraPlotData plotData;
  final String xLabel;
  final String yLabel;
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

class _LineChart extends StatelessWidget {
  const _LineChart({
    super.key,
    required this.xLabel,
    required this.yLabel,
    required this.unitType,
    required this.plotData,
  });

  final SolaraPlotData plotData;
  final String xLabel;
  final String yLabel;
  final SolaraUnitType unitType;

  List<FlSpot> get _flSpots =>
      plotData.entries.map((entry) => FlSpot(entry.key, entry.value)).toList();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: _YAxisTitle(yLabel, unitType).title,
          bottomTitles: _XAxisTitle(xLabel).title,
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

class _YAxisTitle {
  const _YAxisTitle(
    this.label,
    this.unitType,
  );

  final String label;
  final SolaraUnitType unitType;

  int get _divisor => switch (unitType) {
        SolaraUnitType.watts => 1,
        SolaraUnitType.kilowatts => 1000,
      };

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

class _XAxisTitle {
  const _XAxisTitle(this.label);
  final String label;

  String _padDigit(int digit) {
    return digit.toString().length == 1 ? '0$digit' : digit.toString();
  }

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
          interval: 287.0 * Duration.millisecondsPerMinute,
        ),
      );
}
