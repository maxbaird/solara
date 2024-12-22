import 'package:flutter/material.dart';

/// A widget displaying Solara's title.
class SolaraTitle extends StatelessWidget {
  /// Creates a widget for the application's title.
  const SolaraTitle(
    this.title, {
    super.key,
  });

  /// The title of the application.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }
}
