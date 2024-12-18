import 'package:equatable/equatable.dart';

class BatteryEntity extends Equatable {
  const BatteryEntity({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  BatteryEntity copyWith({DateTime? date, int? watts}) => BatteryEntity(
        date: date ?? this.date,
        watts: watts ?? this.watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];
}
