part of 'battery_bloc.dart';

final class BatteryEvent {
  const BatteryEvent();
}

final class Fetch extends BatteryEvent {
  const Fetch({required this.date});

  final DateTime date;
}

final class ToggleWatts extends BatteryEvent {
  const ToggleWatts({required this.showKilowatt});

  final bool showKilowatt;
}
