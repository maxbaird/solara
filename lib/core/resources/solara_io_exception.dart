import 'package:http/http.dart';

/// The exception type for IO operations.
enum IOExceptionType {
  /// If the IO operation times out.
  connectTimeout,

  /// If the server request fails.
  server,

  /// If there was an error with local storage IO.
  localStorage,

  /// Any other error.
  other,

  /// Error performing a conversion.
  conversion,
}

/// IO exceptions thrown by the application when interacting with an IO device.
///
/// IO devices are typically local storage or over the internet.
class SolaraIOException implements Exception {
  SolaraIOException({
    this.response,
    this.error,
    this.errorMap,
    this.type = IOExceptionType.other,
  });

  /// The type of IOException.
  IOExceptionType type;

  /// The response (typically an http response).
  Response? response;

  /// The error that occurred.
  dynamic error;

  /// An error map to parse any error messages from the server.
  Map<String, String>? errorMap;

  /// The stacktrace of the exception.
  StackTrace? stackTrace;

  /// A string representation of [error].
  String get message => error?.toString() ?? '';

  @override
  String toString() {
    var msg = 'Error: $message';
    if (error is Error) {
      msg += '\n${(error as Error).stackTrace}';
    }
    if (stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }
    return msg;
  }
}
