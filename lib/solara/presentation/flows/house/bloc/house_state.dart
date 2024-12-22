part of 'house_bloc.dart';

/// Holds the state data for [HouseBloc].
///
/// Any state data needed by the presentation layer that [HouseBloc] is
/// responsible for is initialized and updated in this class.
final class HouseState extends Equatable {
  const HouseState({
    required this.date,
    required this.unitType,
    required this.plotData,
    required this.blocStatus,
  });

  /// The date associated with the [plotData] being displayed.
  final DateTime date;

  /// The current units used to display the wattage.
  final SolaraUnitType unitType;

  /// The raw data used to plot the line graph.
  final SolaraPlotData plotData;

  /// The status of [HouseBloc].
  ///
  /// When handling events the bloc emits various states to the UI. The UI can
  /// then decide what to display to the user based on the bloc's status.
  final SolaraBlocStatus blocStatus;

  /// Properties used to determine whether the bloc's state is changed.
  ///
  /// [plotData] has been omitted because it is a read only value and will only
  /// be updated from the back-end.
  @override
  List<Object> get props => [
        date,
        unitType,
        blocStatus,
      ];

  /// A utility method to quickly create a new instance of an existing state.
  HouseState copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
    SolaraBlocStatus? blocStatus,
  }) =>
      HouseState(
        date: date ?? this.date,
        unitType: unitType ?? this.unitType,
        plotData: plotData ?? this.plotData,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

final class HouseInitial extends HouseState {
  const HouseInitial({
    required super.date,
    required super.unitType,
    required super.plotData,
    required super.blocStatus,
  });
}
