import 'package:flutter/material.dart';

/// Standard date picker for all date selection.
Future<DateTime?> solaraDatePicker(
        {required BuildContext context, DateTime? initialDate}) =>
    showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: initialDate,
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );
