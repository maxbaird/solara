import '../../../../../core/presentation/model/ui_model.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/entities/battery.dart';

class BatteryUiModel implements UiModel {
  BatteryUiModel({
    required DateTime date,
    required SolaraUnitType unitType,
    required SolaraPlotData plotData,
  })  : _date = date,
        _unitType = unitType,
        _plotData = plotData;

  BatteryUiModel.fromEntityList({
    required List<BatteryEntity> batteryEntities,
    required DateTime date,
  }) {
    _date = date;
    _unitType = SolaraUnitType.watts;

    /// Filter away null dates and keep dates that exactly match [date]
    batteryEntities = batteryEntities.where((e) {
      final DateTime? d = e.date;
      if (d != null) {
        return d.year == _date.year &&
            d.month == _date.month &&
            d.day == _date.day;
      }
      return false;
    }).toList();

    /// Populate [plotData] with data from filtered [batteryEntities].
    for (var batteryEntity in batteryEntities) {
      double? date = batteryEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = batteryEntity.watts?.toDouble();
      if (date != null && watts != null) {
        _plotData[date] = watts;
      }
    }
  }

  /// The date associated with the [plotData] being displayed.
  late final DateTime _date;

  /// The current units used to display the wattage.
  late final SolaraUnitType _unitType;

  /// The raw data used to plot the line graph.
  late final SolaraPlotData _plotData;

  @override
  String get date => _date.toIso8601String();

  @override
  String get unitType => _unitType.unit;

  @override
  SolaraPlotData get plotData => _plotData;

  BatteryUiModel copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
  }) =>
      BatteryUiModel(
        date: date ?? _date,
        unitType: unitType ?? _unitType,
        plotData: plotData ?? _plotData,
      );
}
