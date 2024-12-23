import 'dart:io' show Platform;

/// The Url of the remote connection hosting the endpoints.
String get baseUrl =>
    Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
