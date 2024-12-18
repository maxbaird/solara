import 'package:equatable/equatable.dart';
import '../../domain/entities/solar.dart';

class SolarModel extends Equatable {
  const SolarModel({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  SolarModel.fromJson(Map<String, dynamic> json)
      : date = json['timestamp'],
        watts = json['value'];

  SolarEntity toEntity() => SolarEntity(
        date: date,
        watts: watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];

  @override
  String toString() => '''SolarModel{
    date: $date,
    watts: $watts,
  }
  ''';
}
