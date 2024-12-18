import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class RepoConfig {
  RepoConfig({
    required this.baseUrl,
  });

  final String baseUrl;
  final http.Client _client = RetryClient(http.Client());
  http.Client get client => _client;
  final successCodes = [200, 201, 202, 204];

  final Map<String, String> dataHeader = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
}
