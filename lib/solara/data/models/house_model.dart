import 'package:equatable/equatable.dart';

import '../../domain/entities/house.dart';

class HouseModel extends Equatable {
  const HouseModel({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  HouseModel.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['timestamp']),
        watts = json['value'];

  HouseModel.fromEntity(HouseEntity battery)
      : date = battery.date,
        watts = battery.watts;

  Map<String, dynamic> toJson() => {
        'timestamp': date?.toIso8601String() ?? '',
        'value': watts,
      };

  HouseEntity toEntity() => HouseEntity(
        date: date,
        watts: watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];

  @override
  String toString() => '''HouseModel{
    date: $date,
    watts: $watts,
  }
  ''';
}
