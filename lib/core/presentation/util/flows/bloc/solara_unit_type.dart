/// The type of units displayed on graphs.
enum SolaraUnitType {
  /// Units in watts with no unit label.
  watts(''),

  /// Units in kilowatts.
  kilowatts('kW');

  final String unit;
  const SolaraUnitType(this.unit);
}
