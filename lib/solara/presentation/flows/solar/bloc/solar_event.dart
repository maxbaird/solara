part of 'solar_bloc.dart';

final class SolarEvent {
  const SolarEvent();
}

final class Fetch extends SolarEvent {
  const Fetch({required this.date});

  final DateTime date;
}

final class ToggleWatts extends SolarEvent {
  const ToggleWatts({required this.showKilowatt});

  final bool showKilowatt;
}
