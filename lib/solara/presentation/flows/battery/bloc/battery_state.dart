part of 'battery_bloc.dart';

/// Holds the state data for [BatteryBloc].
///
/// Any state data needed by the presentation layer that [BatteryBloc] is
/// responsible for is initialized and updated in this class.
final class BatteryState extends Equatable {
  const BatteryState({
    required this.date,
    required this.unitType,
    required this.plotData,
    required this.batteryUiModel,
    required this.blocStatus,
  });

  /// The date associated with the [plotData] being displayed.
  final DateTime date;

  /// The current units used to display the wattage.
  final SolaraUnitType unitType;

  /// The raw data used to plot the line graph.
  final SolaraPlotData plotData;

  final BatteryUiModel batteryUiModel;

  /// The status of [BatteryBloc].
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
        batteryUiModel,
        blocStatus,
      ];

  /// A utility method to quickly create a new instance of an existing state.
  BatteryState copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
    BatteryUiModel? batteryUiModel,
    SolaraBlocStatus? blocStatus,
  }) =>
      BatteryState(
        date: date ?? this.date,
        unitType: unitType ?? this.unitType,
        plotData: plotData ?? this.plotData,
        batteryUiModel: batteryUiModel ?? this.batteryUiModel,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

/// The initial state of the bloc.
final class BatteryInitial extends BatteryState {
  const BatteryInitial({
    required super.date,
    required super.unitType,
    required super.plotData,
    required super.batteryUiModel,
    required super.blocStatus,
  });
}
