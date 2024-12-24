import 'package:equatable/equatable.dart';

import '../util/flows/bloc/solara_unit_type.dart';
import '../util/flows/solara_plot_data.dart';

/// Contains the fields that all UiModels for Solara must expose.
abstract interface class UiModel {
  /// The date of [plotData] being used for the chart.
  DateTime get date;

  /// The type of units to use when labelling the y-axis of the chart.
  SolaraUnitType get unitType;

  /// The data used to plot the chart.
  SolaraPlotData get plotData;
}
