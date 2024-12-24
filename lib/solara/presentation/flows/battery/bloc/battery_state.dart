part of 'battery_bloc.dart';

/// Holds the state data for [BatteryBloc].
///
/// Any state data needed by the presentation layer that [BatteryBloc] is
/// responsible for is initialized and updated in this class.
final class BatteryState extends Equatable {
  const BatteryState({
    required this.batteryUiModel,
    required this.blocStatus,
  });

  /// The presentation data for the UI.
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
        blocStatus,
      ];

  /// A utility method to quickly create a new instance of an existing state.
  BatteryState copyWith({
    BatteryUiModel? batteryUiModel,
    SolaraBlocStatus? blocStatus,
  }) =>
      BatteryState(
        batteryUiModel: batteryUiModel ?? this.batteryUiModel,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

/// The initial state of the bloc.
final class BatteryInitial extends BatteryState {
  const BatteryInitial({
    required super.batteryUiModel,
    required super.blocStatus,
  });
}
