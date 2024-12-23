import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/presentation/widgets/solara_home.dart';
import 'package:solara/injection_container.dart' as injection_container;
import 'package:solara/solara/domain/usecases/clear_storage_usecase.dart';

class MockClearStorageUseCase extends Mock implements ClearStorageUseCase {}

void main() {
  final mockClearStorageUseCase = MockClearStorageUseCase();

  setUpAll(() {
    injection_container.init();
  });

  group('solaraHome', () {
    testWidgets('house widget is displayed', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraHome(
            key: const Key('solaraHome'),
            houseWidget: Placeholder(key: Key('houseWidget')),
            batteryWidget: Placeholder(key: Key('batteryWidget')),
            solarWidget: Placeholder(key: Key('solarWidget')),
            clearStorageUseCase: mockClearStorageUseCase,
          ),
        ),
      ));

      expect(find.byKey(Key('solaraHome')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.house));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('houseWidget')), findsOneWidget);
    });

    testWidgets('battery widget is displayed', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraHome(
            key: const Key('solaraHome'),
            houseWidget: Placeholder(key: Key('houseWidget')),
            batteryWidget: Placeholder(key: Key('batteryWidget')),
            solarWidget: Placeholder(key: Key('solarWidget')),
            clearStorageUseCase: mockClearStorageUseCase,
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.battery_charging_full));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('batteryWidget')), findsOneWidget);
    });

    testWidgets('solar widget is displayed', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraHome(
            key: const Key('solaraHome'),
            houseWidget: Placeholder(key: Key('houseWidget')),
            batteryWidget: Placeholder(key: Key('batteryWidget')),
            solarWidget: Placeholder(key: Key('solarWidget')),
            clearStorageUseCase: mockClearStorageUseCase,
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.solar_power_outlined));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('solarWidget')), findsOneWidget);
    });

    testWidgets('app bar is displayed', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraHome(
            key: const Key('solaraHome'),
            houseWidget: Placeholder(key: Key('houseWidget')),
            batteryWidget: Placeholder(key: Key('batteryWidget')),
            solarWidget: Placeholder(key: Key('solarWidget')),
            clearStorageUseCase: mockClearStorageUseCase,
          ),
        ),
      ));

      expect(find.byKey(Key('solaraAppBar')), findsOneWidget);
    });

    testWidgets('clear cache button', (tester) async {
      bool cacheClearedCalled = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SolaraHome(
            key: const Key('solaraHome'),
            houseWidget: Placeholder(key: Key('houseWidget')),
            batteryWidget: Placeholder(key: Key('batteryWidget')),
            solarWidget: Placeholder(key: Key('solarWidget')),
            clearStorageUseCase: mockClearStorageUseCase,
          ),
        ),
      ));

      when(() => mockClearStorageUseCase.call(params: null))
          .thenAnswer((_) async {
        cacheClearedCalled = true;
      });

      expect(find.byKey(Key('clearCache')), findsOneWidget);
      await tester.tap(find.byKey(Key('clearCache')));
      expect(cacheClearedCalled, true);
    });
  });
}
