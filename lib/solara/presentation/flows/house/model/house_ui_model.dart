import '../../../../../core/presentation/model/ui_model.dart';
import '../../../../../core/presentation/util/flows/bloc/solara_unit_type.dart';
import '../../../../../core/presentation/util/flows/solara_plot_data.dart';
import '../../../../domain/entities/house.dart';

class HouseUiModel implements UiModel {
  HouseUiModel({
    required DateTime date,
    required SolaraUnitType unitType,
    required SolaraPlotData plotData,
  })  : _date = date,
        _unitType = unitType,
        _plotData = plotData;

  HouseUiModel.fromEntityList({
    required List<HouseEntity> houseEntities,
    required DateTime date,
    required SolaraUnitType unitType,
  }) {
    _date = date;
    _unitType = unitType;
    _plotData = <double, double>{};

    /// Filter away null dates and keep dates that exactly match [date]
    houseEntities = houseEntities.where((e) {
      final DateTime? d = e.date;
      if (d != null) {
        return d.year == _date.year &&
            d.month == _date.month &&
            d.day == _date.day;
      }
      return false;
    }).toList();

    /// Populate [plotData] with data from filtered [houseEntities].
    for (var houseEntity in houseEntities) {
      double? date = houseEntity.date?.millisecondsSinceEpoch.toDouble();
      double? watts = houseEntity.watts?.toDouble();
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

  HouseUiModel copyWith({
    DateTime? date,
    SolaraUnitType? unitType,
    SolaraPlotData? plotData,
  }) =>
      HouseUiModel(
        date: date ?? _date,
        unitType: unitType ?? _unitType,
        plotData: plotData ?? _plotData,
      );
}
