import 'package:flutter/material.dart';

import 'injection_container.dart' as dependency_injector;
import 'solara/presentation/graph/screens/graph.dart';

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
      home: const _Solara(),
    );
  }
}

class _Solara extends StatelessWidget {
  const _Solara({super.key});

  @override
  Widget build(BuildContext context) {
    return const Graph();
  }
}
