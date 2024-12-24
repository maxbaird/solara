part of 'house_bloc.dart';

/// Holds the state data for [HouseBloc].
///
/// Any state data needed by the presentation layer that [HouseBloc] is
/// responsible for is initialized and updated in this class.
final class HouseState extends Equatable {
  const HouseState({
    required this.houseUiModel,
    required this.blocStatus,
  });

  /// The presentation data for the UI.
  final HouseUiModel houseUiModel;

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
        houseUiModel,
        blocStatus,
      ];

  /// A utility method to quickly create a new instance of an existing state.
  HouseState copyWith({
    HouseUiModel? houseUiModel,
    SolaraBlocStatus? blocStatus,
  }) =>
      HouseState(
        houseUiModel: houseUiModel ?? this.houseUiModel,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

/// The initial state of the bloc.
final class HouseInitial extends HouseState {
  const HouseInitial({
    required super.houseUiModel,
    required super.blocStatus,
  });
}
