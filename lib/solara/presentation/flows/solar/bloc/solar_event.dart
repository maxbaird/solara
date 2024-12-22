part of 'solar_bloc.dart';

/// Emit a success state.
final class SolarEvent {
  const SolarEvent();
}

/// The fetch event.
///
/// Invoked when the user requests a new chart by providing a new date.
final class Fetch extends SolarEvent {
  const Fetch({required this.date});

  /// The date to fetch chart data for.
  final DateTime date;
}

/// The ToggleWatts event.
///
/// Invoked when the user toggles the wattage units.
final class ToggleWatts extends SolarEvent {
  const ToggleWatts({required this.showKilowatt});

  /// Whether to display the wattage as kilowatts or watts.
  final bool showKilowatt;
}
