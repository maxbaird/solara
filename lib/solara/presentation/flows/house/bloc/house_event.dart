part of 'house_bloc.dart';

/// The base event for the [HouseBloc].
final class HouseEvent {
  const HouseEvent();
}

/// The fetch event.
///
/// Invoked when the user requests a new chart by providing a new date.
final class Fetch extends HouseEvent {
  const Fetch({required this.date});

  /// The date to fetch chart data for.
  final DateTime date;
}

/// The ToggleWatts event.
///
/// Invoked when the user toggles the wattage units.
final class ToggleWatts extends HouseEvent {
  const ToggleWatts({required this.showKilowatt});

  /// Whether to display the wattage as kilowatts or watts.
  final bool showKilowatt;
}
