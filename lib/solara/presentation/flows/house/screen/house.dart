import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solara/core/presentation/util/flows/solara_plot_data.dart';
import 'dart:math' as math;

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
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
            SolaraBlocStatus.success => SolaraGraph(plotData: state.plotData),
            SolaraBlocStatus.failure => const SolaraError(),
            SolaraBlocStatus.noData => const SolaraError(),
          };
        },
      ),
    );
  }
}

class SolaraCircularProgressIndicator extends StatelessWidget {
  const SolaraCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SolaraError extends StatelessWidget {
  const SolaraError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Failed to load data!'));
  }
}

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
                  // spots: [
                  //   FlSpot(
                  //       DateTime.parse('2024-10-03T00:00:00.000Z')
                  //           .millisecondsSinceEpoch
                  //           .toDouble(),
                  //       3029),
                  //   FlSpot(
                  //       DateTime.parse('2024-10-03T00:05:00.000Z')
                  //           .millisecondsSinceEpoch
                  //           .toDouble(),
                  //       6942),
                  //   FlSpot(
                  //       DateTime.parse('2024-10-03T00:10:00.000Z')
                  //           .millisecondsSinceEpoch
                  //           .toDouble(),
                  //       7112),
                  //   FlSpot(
                  //       DateTime.parse('2024-10-03T00:15:00.000Z')
                  //           .millisecondsSinceEpoch
                  //           .toDouble(),
                  //       7700),
                  //   FlSpot(
                  //       DateTime.parse('2024-10-03T00:20:00.000Z')
                  //           .millisecondsSinceEpoch
                  //           .toDouble(),
                  //       5480),
                  // ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
