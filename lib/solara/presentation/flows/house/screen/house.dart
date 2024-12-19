import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            SolaraBlocStatus.success => const SolaraGraph(),
            SolaraBlocStatus.failure => const SolaraFailure(),
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

class SolaraFailure extends StatelessWidget {
  const SolaraFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Failed to load data!'));
  }
}

class SolaraGraph extends StatelessWidget {
  const SolaraGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: AspectRatio(
          aspectRatio: 2.0,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                  reservedSize: 42,
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    return Text(value.toInt().toString());
                  },
                )),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, _) {
                      final DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text('${date.hour}:${date.minute}');
                    },
                    reservedSize: 32,
                    showTitles: true,
                    interval: 5.0 * Duration.millisecondsPerMinute,
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
                  spots: [
                    FlSpot(
                        DateTime.parse('2024-10-03T00:00:00.000Z')
                            .millisecondsSinceEpoch
                            .toDouble(),
                        3029),
                    FlSpot(
                        DateTime.parse('2024-10-03T00:05:00.000Z')
                            .millisecondsSinceEpoch
                            .toDouble(),
                        6942),
                    FlSpot(
                        DateTime.parse('2024-10-03T00:10:00.000Z')
                            .millisecondsSinceEpoch
                            .toDouble(),
                        7112),
                    FlSpot(
                        DateTime.parse('2024-10-03T00:15:00.000Z')
                            .millisecondsSinceEpoch
                            .toDouble(),
                        7700),
                    FlSpot(
                        DateTime.parse('2024-10-03T00:20:00.000Z')
                            .millisecondsSinceEpoch
                            .toDouble(),
                        5480),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
