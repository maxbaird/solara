import 'dart:convert';

import 'package:http/http.dart';

import '../../../core/resources/solara_io_exception.dart';
import '../../../core/util/logger.dart';
import '../../../core/util/repo_config.dart';
import '../models/battery_model.dart';

/// Performs the operations for fetching data from a remote
/// API via http requests.
class BatteryRemoteDataSourceImpl extends BatteryRemoteDataSource {
  BatteryRemoteDataSourceImpl(RepoConfig connection, String path)
      : super(connection, path) {
    _url = connection.baseUrl + path;
  }

  /// The Url to the endpoint.
  late final String _url;

  final _log = logger;

  @override
  Future<(List<BatteryModel>?, SolaraIOException?)> fetch(
      {DateTime? date}) async {
    String endPointUrl = _url;
    final params = <String, String>{};

    uri = Uri.parse(endPointUrl);

    if (date != null) {
      // Add the date to the request parameters.
      params['date'] = date.toIso8601String();
    }

    // For this datasource the type will always be 'battery'.
    params['type'] = 'battery';

    uri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
      queryParameters: params,
    );

    _log.i('Fetching Battery from Uri: $uri');

    Response? res;

    try {
      // Make the request to the remote api.
      res = await connection.client.get(uri, headers: connection.dataHeader);
    } catch (e) {
      _log.e(e);
      var err = SolaraIOException(error: e, response: res);
      return (null, err);
    }

    late final int statusCode;

    try {
      statusCode = res.statusCode;
    } catch (e) {
      var err = SolaraIOException(
        error: Exception(
            'Connection failed but had error decoding statusCode: $e'),
        response: res,
        type: IOExceptionType.other,
      );
      return (null, err);
    }

    /// Checks if the status code of [res] is not a success code.
    if (!connection.successCodes.contains(statusCode)) {
      /// If request fails, handle the failure in this scope.
      _log.e('Server error. Code:$statusCode\nBody:${res.body}');

      late final List<dynamic> response;
      try {
        response = json.decode(res.body);
      } catch (e) {
        var err = SolaraIOException(
          error: Exception(
              'Connection failed but had error decoding response: $e'),
          response: res,
          type: IOExceptionType.other,
        );
        return (null, err);
      }

      var err = SolaraIOException(
        error: Exception(response),
        response: res,
        type: IOExceptionType.server,
      );
      return (null, err);
    }

    //Success
    try {
      List<dynamic> items = json.decode(res.body);
      List<BatteryModel> results = [];

      for (var item in items) {
        results.add(BatteryModel.fromJson(item));
      }
      return (results, null);
    } catch (e) {
      _log.e('Populating from Json failed with error: $e');

      var err = SolaraIOException(
        error: e,
        response: res,
        type: IOExceptionType.conversion,
      );
      return (null, err);
    }
  }
}

/// Provides a consistent interface for all
/// remote battery data sources.
abstract class BatteryRemoteDataSource {
  BatteryRemoteDataSource(this.connection, this.path);

  /// The connection information for the remote data source.
  final RepoConfig connection;
  final String path;

  Uri uri = Uri();

  /// Fetches battery models from the remote data source.
  ///
  /// Will return an error if remote fetch fails.
  Future<(List<BatteryModel>?, SolaraIOException?)> fetch({
    DateTime? date,
  });
}
