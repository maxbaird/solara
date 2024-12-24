import '../util/flows/solara_plot_data.dart';

/// Contains the fields that all UiModels for Solara must expose.
abstract interface class UiModel {
  String get date;
  String get unitType;
  SolaraPlotData get plotData;
}
