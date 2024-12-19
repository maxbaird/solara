part of 'house_bloc.dart';

final class HouseEvent {
  const HouseEvent();
}

final class Fetch extends HouseEvent {
  const Fetch({required this.date});

  final DateTime date;
}
