import 'package:http/http.dart';

enum IOExceptionType {
  connectTimeout,
  server,
  localStorage,
  other,
  conversion,
}

class SolaraIOError implements Exception {
  SolaraIOError({
    this.response,
    this.error,
    this.errorMap,
    this.type = IOExceptionType.other,
  });

  IOExceptionType type;

  Response? response;

  dynamic error;
  Map<String, String>? errorMap;
  StackTrace? stackTrace;

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
