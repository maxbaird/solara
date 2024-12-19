import 'package:flutter/material.dart';

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
    return DefaultTabController(
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
    );
  }
}
