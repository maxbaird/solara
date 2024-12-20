part of 'battery_bloc.dart';

final class BatteryState extends Equatable {
  const BatteryState({
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

  BatteryState copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
    SolaraBlocStatus? blocStatus,
  }) =>
      BatteryState(
        date: date ?? this.date,
        unitType: unitType ?? this.unitType,
        plotData: plotData ?? this.plotData,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

final class BatteryInitial extends BatteryState {
  const BatteryInitial({
    required super.date,
    required super.unitType,
    required super.plotData,
    required super.blocStatus,
  });
}
