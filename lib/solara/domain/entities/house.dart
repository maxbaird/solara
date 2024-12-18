import 'package:equatable/equatable.dart';

class HouseEntity extends Equatable {
  const HouseEntity({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  HouseEntity copyWith({DateTime? date, int? watts}) => HouseEntity(
        date: date ?? this.date,
        watts: watts ?? this.watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];
}
