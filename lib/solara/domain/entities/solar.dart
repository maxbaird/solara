import 'package:equatable/equatable.dart';

class SolarEntity extends Equatable {
  const SolarEntity({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  SolarEntity copyWith({DateTime? date, int? watts}) => SolarEntity(
        date: date ?? this.date,
        watts: watts ?? this.watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];
}
