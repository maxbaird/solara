import 'package:flutter/material.dart';
import 'package:solara/core/presentation/widgets/solara_home.dart';

import 'injection_container.dart' as dependency_injector;

void main() {
  dependency_injector.init();

  // var (result, err) = await sl<FetchSolarUseCase>().call(
  //   params: FetchParams(
  //     date: DateTime(2024, 03, 10),
  //   ),
  // );

  // print(result);

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
      homeWidget: const Placeholder(),
      batteryWidget: const Placeholder(),
      solarWidget: const Placeholder(),
    );
  }
}
