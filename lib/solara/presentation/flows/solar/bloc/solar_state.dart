part of 'solar_bloc.dart';

class SolarState extends Equatable {
  const SolarState({
    required this.date,
    required this.unitType,
    required this.plotData,
    required this.blocStatus,
  });

  final DateTime date;
  final SolaraUnitType unitType;
  final SolaraPlotData plotData;
  final SolaraBlocStatus blocStatus;

  @override
  List<Object> get props => [
        date,
        unitType,
        blocStatus,
      ];

  SolarState copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
    SolaraBlocStatus? blocStatus,
  }) =>
      SolarState(
        date: date ?? this.date,
        unitType: unitType ?? this.unitType,
        plotData: plotData ?? this.plotData,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

final class SolarInitial extends SolarState {
  const SolarInitial({
    required super.date,
    required super.unitType,
    required super.plotData,
    required super.blocStatus,
  });
}
