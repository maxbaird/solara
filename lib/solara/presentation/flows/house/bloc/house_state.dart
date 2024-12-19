part of 'house_bloc.dart';

final class HouseState extends Equatable {
  const HouseState({
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
