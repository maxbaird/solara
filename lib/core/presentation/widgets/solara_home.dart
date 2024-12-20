import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });

  final Widget houseWidget;
  final Widget batteryWidget;
  final Widget solarWidget;

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
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: SolaraTitle('Solara'),
            centerTitle: true,
            bottom: TabBar(tabs: [
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
            ]),
          ),
          body: TabBarView(
            children: [
              houseWidget,
              batteryWidget,
              solarWidget,
            ],
          ),
        ),
      ),
    );
  }
}
