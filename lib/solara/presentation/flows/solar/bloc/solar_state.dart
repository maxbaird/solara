part of 'solar_bloc.dart';

/// Holds the state data for [SolarBloc].
///
/// Any state data needed by the presentation layer that [SolarBloc] is
/// responsible for is initialized and updated in this class.
class SolarState extends Equatable {
  const SolarState({
    required this.solarUiModel,
    required this.blocStatus,
  });

  /// The presentation data for the UI.
  final SolarUiModel solarUiModel;

  /// The status of [SolarBloc].
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
  SolarState copyWith({
    SolarUiModel? solarUiModel,
    SolaraBlocStatus? blocStatus,
  }) =>
      SolarState(
        solarUiModel: solarUiModel ?? this.solarUiModel,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

/// The initial state of the bloc.
final class SolarInitial extends SolarState {
  const SolarInitial({
    required super.solarUiModel,
    required super.blocStatus,
  });
}
