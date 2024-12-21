import 'package:equatable/equatable.dart';
import '../../domain/entities/battery.dart';

class BatteryModel extends Equatable {
  const BatteryModel({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  BatteryModel.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['timestamp']),
        watts = json['value'];

  BatteryModel.fromEntity(BatteryEntity battery)
      : date = battery.date,
        watts = battery.watts;

  Map<String, dynamic> toJson() => {
        'timestamp': date?.toIso8601String() ?? '',
        'value': watts,
      };

  BatteryEntity toEntity() => BatteryEntity(
        date: date,
        watts: watts,
      );

  @override
  List<Object?> get props => [
        date,
        watts,
      ];

  @override
  String toString() => '''BatteryModel{
    date: $date,
    watts: $watts,
  }
  ''';
}
