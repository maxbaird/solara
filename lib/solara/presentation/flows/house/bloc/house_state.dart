part of 'house_bloc.dart';

final class HouseState extends Equatable {
  const HouseState({
    required this.date,
    required this.unitType,
    required this.houseEntities,
    required this.blocStatus,
  });

  final DateTime date;
  final SolaraUnitType unitType;
  final List<HouseEntity> houseEntities;
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
    List<HouseEntity>? houseEntities,
    SolaraBlocStatus? blocStatus,
  }) =>
      HouseState(
        date: date ?? this.date,
        unitType: unitType ?? this.unitType,
        houseEntities: houseEntities ?? this.houseEntities,
        blocStatus: blocStatus ?? this.blocStatus,
      );
}

final class HouseInitial extends HouseState {
  const HouseInitial({
    required super.date,
    required super.unitType,
    required super.houseEntities,
    required super.blocStatus,
  });
}
