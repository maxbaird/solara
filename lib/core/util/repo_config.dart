import 'dart:io';
import 'package:http/http.dart' as http;

/// The configuration for the remote repository.
class RepoConfig {
  RepoConfig({
    required this.baseUrl,
    required this.client,
  });

  /// The base Url for the repository.
  ///
  /// Additional paths are added as required by each data source.
  final String baseUrl;

  /// The client to use to establish the connection.
  final http.Client client;

  /// The list of acceptable http success codes.
  final successCodes = [200, 201, 202, 204];

  /// The headers for the request.
  final Map<String, String> dataHeader = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
}
