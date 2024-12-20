import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../util/flows/solara_plot_data.dart';

class SolaraGraph extends StatelessWidget {
  const SolaraGraph({
    super.key,
    this.xLabel = 'Time of Day',
    this.yLabel = 'Watts',
    required this.plotData,
  });

  final SolaraPlotData plotData;
  final String xLabel;
  final String yLabel;

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
    required this.plotData,
  });

  final SolaraPlotData plotData;
  final String xLabel;
  final String yLabel;

  List<FlSpot> get _flSpots =>
      plotData.entries.map((entry) => FlSpot(entry.key, entry.value)).toList();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: _LeftTitle(yLabel).title,
          bottomTitles: _BottomTitle(xLabel).title,
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

class _LeftTitle {
  const _LeftTitle(this.label);

  final String label;

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
            return Text(value.toInt().toString());
          },
        ),
      );
}

class _BottomTitle {
  const _BottomTitle(this.label);
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
          getTitlesWidget: (value, _) {
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
