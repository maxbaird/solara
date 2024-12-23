import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solara/core/presentation/widgets/solara_circular_progress_indicator.dart';

void main() {
  testWidgets('Circular progress indicator is displayed', (tester) async {
    const key = Key('solaraCircularProgressIndicator');

    await tester.pumpWidget(const SolaraCircularProgressIndicator(key: key));

    expect(find.byKey(key), findsOneWidget);
  });
}
