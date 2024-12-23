import 'package:flutter/material.dart';
import 'util/solara_date_picker.dart';

/// A widget to display an informative message.
///
/// If something unexpected occurs; such as failing to fetch data, this widget
/// is useful for giving feedback of such to the user.
class SolaraInformationMessage extends StatelessWidget {
  /// Creates a widget to display an information message to the user.
  ///
  /// User is provided with the option to select a new date.
  /// Centers [message] in parent widget.
  const SolaraInformationMessage({
    super.key,
    required this.message,
    required this.onSelectDate,
  });

  /// The message to display.
  final String message;

  /// Call back to invoke date selection.
  final void Function(DateTime) onSelectDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(message)),
        const SizedBox(height: 16.0),
        ElevatedButton(
          key: Key('solaraDatePicker'),
          onPressed: () async {
            final DateTime? date = await solaraDatePicker(context: context);
            if (!context.mounted || date == null) {
              return;
            }
            onSelectDate(date);
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
