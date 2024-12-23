import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solara/core/presentation/widgets/solara_line_chart.dart';

void main() {
  group('solara line chart', () {
    testWidgets('line chart displayed', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraLineChart(
            key: Key('solaraLineChart'),
            xLabel: 'xLabel',
            yLabel: 'yLabel',
            plotData: {1.0: 1.0},
          ),
        ),
      ));

      expect(find.byKey(Key('solaraLineChart')), findsOneWidget);
      expect(find.text('xLabel'), findsOneWidget);
      expect(find.text('yLabel'), findsOneWidget);
    });
  });
}
