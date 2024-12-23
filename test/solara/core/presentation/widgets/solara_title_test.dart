import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solara/core/presentation/widgets/solara_title.dart';

void main() {
  testWidgets('solara title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const SolaraTitle(
            'title',
            key: Key('solaraTitle'),
          ),
        ),
      ),
    );
    expect(find.byKey(Key('solaraTitle')), findsOneWidget);
  });
}
