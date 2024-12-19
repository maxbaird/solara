import 'package:flutter/material.dart';

class SolaraError extends StatelessWidget {
  const SolaraError({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
