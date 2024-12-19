import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../util/flows/solara_plot_data.dart';

class SolaraGraph extends StatelessWidget {
  const SolaraGraph({
    super.key,
    required this.plotData,
  });

  final SolaraPlotData plotData;

  List<FlSpot> get _flSpots =>
      plotData.entries.map((entry) => FlSpot(entry.key, entry.value)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    axisNameSize: 24.0,
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: const Text('Watts',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                    sideTitles: SideTitles(
                      reservedSize: 42,
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text(value.toInt().toString());
                      },
                    )),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Time of day',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  axisNameSize: 24.0,
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, _) {
                      final DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Transform.rotate(
                          angle: -math.pi / 4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${date.hour}:${date.minute}'),
                          ));
                    },
                    reservedSize: 40,
                    showTitles: true,
                    interval: 287.0 * Duration.millisecondsPerMinute,
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
