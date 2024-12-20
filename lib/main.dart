import 'package:flutter/material.dart';

import 'core/presentation/widgets/solara_home.dart';
import 'injection_container.dart' as dependency_injector;
import 'solara/presentation/flows/battery/screen/battery.dart';
import 'solara/presentation/flows/house/screen/house.dart';

void main() {
  dependency_injector.init();
  runApp(const Solara());
}

class Solara extends StatelessWidget {
  const Solara({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const _Solara(key: Key('_solara')),
    );
  }
}

class _Solara extends StatelessWidget {
  const _Solara({super.key});

  @override
  Widget build(BuildContext context) {
    return SolaraHome(
      houseWidget: const House(),
      batteryWidget: const Battery(),
      solarWidget: const Placeholder(),
    );
  }
}
