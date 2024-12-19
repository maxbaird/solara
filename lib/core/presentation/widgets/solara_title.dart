import 'package:flutter/material.dart';

class SolaraTitle extends StatelessWidget {
  const SolaraTitle(
    this.title, {
    super.key,
  });

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
