import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/util/flows/bloc/solara_bloc_status.dart';
import '../../../../../injection_container.dart';
import '../bloc/house_bloc.dart';

class House extends StatelessWidget {
  const House({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HouseBloc>(
      create: (context) => sl()..add(Fetch(date: DateTime.now())),
      child: BlocBuilder<HouseBloc, HouseState>(
        builder: (context, state) {
          return switch (state.blocStatus) {
            SolaraBlocStatus.initial => const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.inProgress =>
              const SolaraCircularProgressIndicator(),
            SolaraBlocStatus.success => const SolaraGraph(),
            SolaraBlocStatus.failure => const SolaraFailure(),
          };
        },
      ),
    );
  }
}

class SolaraCircularProgressIndicator extends StatelessWidget {
  const SolaraCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SolaraFailure extends StatelessWidget {
  const SolaraFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Failed to load data!'));
  }
}

class SolaraGraph extends StatelessWidget {
  const SolaraGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Success! (Graph)'));
  }
}
