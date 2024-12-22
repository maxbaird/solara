import 'package:flutter/material.dart';

/// A widget to display an informative message.
///
/// If something unexpected occurs; such as failing to fetch data, this widget
/// is useful for giving feedback of such to the user.
class SolaraInformationMessage extends StatelessWidget {
  /// Creates a widget to display an information message to the user.
  ///
  /// Centers [message] in parent widget.
  const SolaraInformationMessage({
    super.key,
    required this.message,
  });

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
