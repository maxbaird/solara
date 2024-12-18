import 'package:http/http.dart';

enum HttpExceptionType {
  connectTimeout,
  server,
  localStorage,
  other,
  conversion,
}

class HttpError implements Exception {
  HttpError({
    this.response,
    this.error,
    this.errorMap,
    this.type = HttpExceptionType.other,
  });

  HttpExceptionType type;

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
