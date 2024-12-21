import 'dart:convert';

import 'package:http/http.dart';

import '../../../core/resources/solara_io_error.dart';
import '../../../core/util/logger.dart';
import '../../../core/util/repo_config.dart';
import '../models/solar_model.dart';

class SolarRemoteDataSourceImpl extends SolarRemoteDataSource {
  SolarRemoteDataSourceImpl(RepoConfig connection, String path)
      : super(connection, path) {
    _url = connection.baseUrl + path;
  }

  late final String _url;

  final _log = logger;

  @override
  Future<(List<SolarModel>?, SolaraIOError?)> fetch({DateTime? date}) async {
    String endPointUrl = _url;
    final params = <String, String>{};

    uri = Uri.parse(endPointUrl);

    if (date != null) {
      params['date'] = date.toIso8601String();
    }

    params['type'] = 'solar';

    uri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
      queryParameters: params,
    );

    _log.i('Fetching Solar from Uri: $uri');

    Response? res;

    try {
      res = await connection.client.get(uri, headers: connection.dataHeader);
    } catch (e) {
      _log.e(e);
      var err = SolaraIOError(error: e, response: res);
      return (null, err);
    }

    if (!connection.successCodes.contains(res.statusCode)) {
      _log.e('Server error. Code:${res.statusCode}\nBody:${res.body}');

      Map<String, dynamic> responseErrorMap = json.decode(res.body);
      final errorData = responseErrorMap['data'];

      var err = SolaraIOError(
        error: Exception(errorData),
        response: res,
        type: IOExceptionType.server,
      );
      return (null, err);
    }

    //Success
    try {
      List<dynamic> items = json.decode(res.body);
      List<SolarModel> results = [];

      for (var item in items) {
        results.add(SolarModel.fromJson(item));
      }
      return (results, null);
    } catch (e) {
      _log.e('Populating from Json failed with error: $e');

      var err = SolaraIOError(
        error: e,
        response: res,
        type: IOExceptionType.conversion,
      );
      return (null, err);
    }
  }
}

abstract class SolarRemoteDataSource {
  SolarRemoteDataSource(this.connection, this.path);

  final RepoConfig connection;
  final String path;

  Uri uri = Uri();

  Future<(List<SolarModel>?, SolaraIOError?)> fetch({
    DateTime? date,
  });
}
