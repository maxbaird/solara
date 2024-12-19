import 'package:flutter/material.dart';

import 'solara_title.dart';

class SolaraHome extends StatelessWidget {
  const SolaraHome({
    super.key,
    required this.homeWidget,
    required this.batteryWidget,
    required this.solarWidget,
  });

  final Widget homeWidget;
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
              icon: Icon(Icons.home),
              child: const Text('Home'),
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
            homeWidget,
            batteryWidget,
            solarWidget,
          ],
        ),
      ),
    );
  }
}
