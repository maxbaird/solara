import 'dart:io';
import 'package:http/http.dart' as http;

class RepoConfig {
  RepoConfig({
    required this.baseUrl,
    required this.client,
  });

  final String baseUrl;
  final http.Client client;
  final successCodes = [200, 201, 202, 204];

  final Map<String, String> dataHeader = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
}
