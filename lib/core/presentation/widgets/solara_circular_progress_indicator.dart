import 'package:flutter/material.dart';

/// Indeterminate progress indicator.
///
/// Displayed to user when Solara is fetching or processing data.
class SolaraCircularProgressIndicator extends StatelessWidget {
  /// Creates a widget that displays a circular progress indicator.
  ///
  /// The widget is centered within its parent widget.
  const SolaraCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
