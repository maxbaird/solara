import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../solara/domain/usecases/clear_storage_usecase.dart';
import '../../../solara/presentation/flows/battery/bloc/battery_bloc.dart'
    as battery_bloc;
import '../../../solara/presentation/flows/house/bloc/house_bloc.dart'
    as house_bloc;
import '../../../solara/presentation/flows/solar/bloc/solar_bloc.dart'
    as solar_bloc;
import 'solara_title.dart';

/// A widget that displays the main tabs for Solara.
///
/// The tabs displayed contain the line charts for [houseWidget],
/// [batteryWidget] and [solarWidget].
///
/// There is also the option to clear Solara's cache.
class SolaraHome extends StatelessWidget {
  /// {@template solara.widgets.solaraHome.solaraHome}
  /// Creates a widget that displays the main interface of Solara.
  /// {@endtemplate}
  const SolaraHome({
    super.key,
    required this.houseWidget,
    required this.batteryWidget,
    required this.solarWidget,
    required this.clearStorageUseCase,
  });

  /// {@template solara.widgets.solaraHome.houseWidget}
  /// The widget to display in the house tab.
  /// {@endtemplate}
  final Widget houseWidget;

  /// {@template solara.widgets.solaraHome.batteryWidget}
  /// The widget to display in the battery tab.
  /// {@endtemplate}
  final Widget batteryWidget;

  /// {@template solara.widgets.solaraHome.solarWidget}
  /// The widget to display in the solar tab.
  /// {@endtemplate}
  final Widget solarWidget;

  /// The usecase to invoke to clear the application's cache.
  final ClearStorageUseCase clearStorageUseCase;

  /// {@template solara.widgets.solaraHome._onClearCache}
  /// Invoked when user selects the option to clear the application's cache.
  /// {@endtemplate}
  void _onClearCache() async => await clearStorageUseCase.call(params: null);

  @override
  Widget build(BuildContext context) {
    /// The blocs provided here are responsible for fetching graph data upon
    /// creation.
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

/// A widget to display the content of the tabs of Solara.
class _SolaraHome extends StatelessWidget {
  /// {@macro solara.widgets.solaraHome.solaraHome}
  const _SolaraHome({
    super.key,
    required this.houseWidget,
    required this.batteryWidget,
    required this.solarWidget,
    required this.onClearCache,
  });

  /// {@macro solara.widgets.solaraHome.houseWidget}
  final Widget houseWidget;

  /// {@macro solara.widgets.solaraHome.batteryWidget}
  final Widget batteryWidget;

  /// {@macro solara.widgets.solaraHome.solarWidget}
  final Widget solarWidget;

  /// {@macro solara.widgets.solaraHome._onClearCache}
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
