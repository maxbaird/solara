import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';

/// Contains the fields that all UiModels for Solara must expose.
abstract interface class UiModel {
  DateTime get date;
  SolaraUnitType get unitType;
  SolaraPlotData get plotData;
}
