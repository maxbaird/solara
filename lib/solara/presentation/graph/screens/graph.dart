import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Solara',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(
              child: const Text('Home'),
            ),
            Tab(
              child: const Text('Battery'),
            ),
            Tab(
              child: const Text('Solar'),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text('Home'),
            ),
            Center(
              child: Text('Battery'),
            ),
            Center(
              child: Text('Solar'),
            ),
          ],
        ),
      ),
    );
  }
}
