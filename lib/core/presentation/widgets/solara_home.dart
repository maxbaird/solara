import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solara/solara/domain/usecases/clear_storage_usecase.dart';

import '../../../injection_container.dart';
import '../../../solara/presentation/flows/battery/bloc/battery_bloc.dart'
    as battery_bloc;
import '../../../solara/presentation/flows/house/bloc/house_bloc.dart'
    as house_bloc;
import '../../../solara/presentation/flows/solar/bloc/solar_bloc.dart'
    as solar_bloc;
import 'solara_title.dart';

class SolaraHome extends StatelessWidget {
  const SolaraHome({
    super.key,
    required this.houseWidget,
    required this.batteryWidget,
    required this.solarWidget,
    required this.clearStorageUseCase,
  });

  final Widget houseWidget;
  final Widget batteryWidget;
  final Widget solarWidget;
  final ClearStorageUseCase clearStorageUseCase;

  void _onClearCache() async => await clearStorageUseCase.call(params: null);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<house_bloc.HouseBloc>(
          create: (context) =>
              sl()..add(house_bloc.Fetch(date: DateTime.now())),
          lazy: false,
        ),
        BlocProvider<battery_bloc.BatteryBloc>(
          create: (context) =>
              sl()..add(battery_bloc.Fetch(date: DateTime.now())),
          lazy: false,
        ),
        BlocProvider<solar_bloc.SolarBloc>(
          create: (context) =>
              sl()..add(solar_bloc.Fetch(date: DateTime.now())),
          lazy: false,
        ),
      ],
      child: _SolaraHome(
        key: const Key('_solaraHome'),
        houseWidget: houseWidget,
        batteryWidget: batteryWidget,
        solarWidget: solarWidget,
        onClearCache: _onClearCache,
      ),
    );
  }
}

class _SolaraHome extends StatelessWidget {
  const _SolaraHome({
    super.key,
    required this.houseWidget,
    required this.batteryWidget,
    required this.solarWidget,
    required this.onClearCache,
  });

  final Widget houseWidget;
  final Widget batteryWidget;
  final Widget solarWidget;
  final void Function() onClearCache;

  List<Widget> get _actions => [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton.icon(
            onPressed: onClearCache,
            label: const Text('Clear Cache'),
            icon: Icon(Icons.delete),
          ),
        )
      ];

  TabBar get _bottom => TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.house),
            child: const Text('House'),
          ),
          Tab(
            icon: Icon(Icons.battery_charging_full),
            child: const Text('Battery'),
          ),
          Tab(
            icon: Icon(Icons.solar_power_outlined),
            child: const Text('Solar'),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: SolaraTitle('Solara'),
          centerTitle: true,
          actions: _actions,
          bottom: _bottom,
        ),
        body: TabBarView(
          children: [
            houseWidget,
            batteryWidget,
            solarWidget,
          ],
        ),
      ),
    );
  }
}
