import 'package:logger/logger.dart';

/// A logger for information, warnings and errors.
final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    noBoxingByDefault: true,
    errorMethodCount: 1,
    methodCount: 2,
    stackTraceBeginIndex: 1,
  ),
);
