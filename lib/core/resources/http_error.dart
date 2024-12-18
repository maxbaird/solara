import 'package:http/http.dart';

class HttpError implements Exception {
  HttpError({
    this.response,
    this.error,
    this.errorMap,
  });

  /// Response info, it may be `null` if the request can't reach to
  /// the http server, for example, occurring a dns error, network is not
  /// available.
  Response? response;

  /// The original error/exception object.
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
