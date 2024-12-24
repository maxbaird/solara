import '../../../../../core/presentation/model/ui_model.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/entities/solar.dart';

class SolarUiModel implements UiModel {
  SolarUiModel({
    required DateTime date,
    required SolaraUnitType unitType,
    required SolaraPlotData plotData,
  })  : _date = date,
        _unitType = unitType,
        _plotData = plotData;

  SolarUiModel.fromEntityList({
    required List<SolarEntity> solarEntities,
    required DateTime date,
  }) {
    _date = date;
    _unitType = SolaraUnitType.watts;
    _plotData = <double, double>{};

    /// Filter away null dates and keep dates that exactly match [date]
    solarEntities = solarEntities.where((e) {
      final DateTime? d = e.date;
      if (d != null) {
        return d.year == _date.year &&
            d.month == _date.month &&
            d.day == _date.day;
      }
      return false;
    }).toList();

    /// Populate [plotData] with data from filtered [solarEntities].
    for (var solarEntity in solarEntities) {
      double? date = solarEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = solarEntity.watts?.toDouble();
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
  DateTime get date => _date;

  @override
  SolaraUnitType get unitType => _unitType;

  @override
  SolaraPlotData get plotData => _plotData;

  SolarUiModel copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
  }) =>
      SolarUiModel(
        date: date ?? _date,
        unitType: unitType ?? _unitType,
        plotData: plotData ?? _plotData,
      );
}
