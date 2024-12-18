import 'package:equatable/equatable.dart';
import 'package:solara/solara/domain/entities/house.dart';

class HouseModel extends Equatable {
  const HouseModel({
    this.date,
    this.watts,
  });

  final DateTime? date;
  final int? watts;

  HouseModel.fromJson(Map<String, dynamic> json)
      : date = json['timestamp'],
        watts = json['value'];

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
