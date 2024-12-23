import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solara/core/presentation/widgets/solara_information_message.dart';

void main() {
  group('solaraInformationMessage', () {
    testWidgets('information widget displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolaraInformationMessage(
              key: const Key('solaraInformationMessage'),
              message: 'Information Message',
              onSelectDate: (_) {},
            ),
          ),
        ),
      );
      expect(find.byKey(Key('solaraInformationMessage')), findsOneWidget);
    });

    testWidgets('date picker button rendered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolaraInformationMessage(
              key: const Key('solaraInformationMessage'),
              message: 'Information Message',
              onSelectDate: (_) {},
            ),
          ),
        ),
      );
      expect(find.byKey(Key('solaraDatePicker')), findsOneWidget);
    });

    testWidgets('date picker displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolaraInformationMessage(
              key: const Key('solaraInformationMessage'),
              message: 'Information Message',
              onSelectDate: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('solaraDatePicker')));
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('date picker date selection', (tester) async {
      DateTime? date;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolaraInformationMessage(
              key: const Key('solaraInformationMessage'),
              message: 'Information Message',
              onSelectDate: (d) => date = d,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('solaraDatePicker')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      DateTime now = DateTime.now();
      expect(date, isNotNull);
      expect(date!.isAtSameMomentAs(DateTime(now.year, now.month, 15)), true);
    });
  });
}
