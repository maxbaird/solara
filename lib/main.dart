import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/bloc/theme_bloc.dart';
import 'core/presentation/widgets/solara_home.dart';
import 'injection_container.dart' as dependency_injector;
import 'solara/presentation/flows/battery/screen/battery.dart';
import 'solara/presentation/flows/house/screen/house.dart';
import 'solara/presentation/flows/solar/screen/solar.dart';

void main() async {
  await dependency_injector.init();
  runApp(const Solara());
}

class Solara extends StatelessWidget {
  const Solara({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: Builder(builder: (context) {
        final theme = context.watch<ThemeBloc>().state;
        // context.read<ThemeBloc>().add(const ThemeSwitchEvent());
        return MaterialApp(
          theme: theme,
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          //   useMaterial3: true,
          // ),
          home: const _Solara(key: Key('_solara')),
        );
      }),
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
      solarWidget: const Solar(),
      clearStorageUseCase: dependency_injector.sl(),
    );
  }
}
