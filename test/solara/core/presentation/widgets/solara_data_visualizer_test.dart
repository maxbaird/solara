import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solara/core/presentation/util/flows/bloc/solara_unit_type.dart';
import 'package:solara/core/presentation/widgets/solara_data_visualizer.dart';

void main() {
  group('Data visualizer tests', () {
    testWidgets('data visualizer has shows graph', (tester) async {
      const key = Key('solaraDataVisualizer');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: key,
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (_) {},
          ),
        ),
      ));

      expect(find.byKey(key), findsOneWidget);
      expect(find.byKey(const Key('solaraGraph')), findsOneWidget);
    });

    testWidgets('data visualizer shows bottom row', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (_) {},
          ),
        ),
      ));

      expect(find.byKey(const Key('solaraBottomRow')), findsOneWidget);
    });

    testWidgets('data visualizer shows switch to toggle units', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (_) {},
          ),
        ),
      ));

      expect(find.byKey(const Key('solaraToggleUnit')), findsOneWidget);
    });

    testWidgets('data visualizer shows button to select date', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (_) {},
          ),
        ),
      ));

      expect(find.byKey(const Key('solaraDateSelect')), findsOneWidget);
    });

    testWidgets('data visualizer shows date picker', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (_) {},
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('solaraDateSelect')));
      await tester.pumpAndSettle();

      // Date picker has ok and cancel buttons.
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Able to select date from date picker', (tester) async {
      DateTime? date;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (_) {},
            onDateChange: (d) => date = d,
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('solaraDateSelect')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(date, isNotNull);
      expect(
          date!.isAtSameMomentAs(
              DateTime(DateTime.now().year, DateTime.now().month, 15)),
          true);
    });

    testWidgets('toggle for wattage units', (tester) async {
      bool showKilowatt = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraDataVisualizer(
            key: const Key('solarDataVisualizer'),
            date: DateTime.now(),
            plotData: {1.0: 1.0},
            unitType: SolaraUnitType.watts,
            onToggleUnit: (showKilo) => showKilowatt = showKilo,
            onDateChange: (_) {},
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('solaraToggleUnit')));
      await tester.pumpAndSettle();

      expect(showKilowatt, true);
    });
  });
}
