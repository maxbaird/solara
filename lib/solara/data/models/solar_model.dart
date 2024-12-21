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
      : date = DateTime.parse(json['timestamp']),
        watts = json['value'];

  SolarModel.fromEntity(SolarEntity solar)
      : date = solar.date,
        watts = solar.watts;

  Map<String, dynamic> toJson() => {
        'timestamp': date?.toIso8601String() ?? '',
        'value': watts,
      };

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
