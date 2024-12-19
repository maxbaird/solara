import 'dart:convert';
import 'package:http/http.dart';
import '../../../core/util/repo_config.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/util/logger.dart';
import '../models/solar_model.dart';

class SolarRemoteDataSourceImpl extends SolarRemoteDataSource {
  SolarRemoteDataSourceImpl(RepoConfig connection, String path)
      : super(connection, path) {
    _endPointUrl = connection.baseUrl + path;
  }

  late final String _endPointUrl;

  final _log = logger;

  @override
  Future<(List<SolarModel>?, HttpError?)> fetch({DateTime? date}) async {
    uri = Uri.parse(_endPointUrl);
    uri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
    );

    _log.i('Fetching Lookup from URL: $uri');

    Response? res;

    try {
      res = await connection.client.get(uri, headers: connection.dataHeader);
    } catch (e) {
      _log.e(e);
      var err = HttpError(error: e, response: res);
      return (null, err);
    }

    if (!connection.successCodes.contains(res.statusCode)) {
      _log.e('Server error. Code:${res.statusCode}\nBody:${res.body}');

      Map<String, dynamic> responseErrorMap = json.decode(res.body);
      final errorData = responseErrorMap['data'];

      var err = HttpError(
        error: Exception(errorData),
        response: res,
        type: HttpExceptionType.server,
      );
      return (null, err);
    }

    //Success
    try {
      Map<String, dynamic> responseMap = json.decode(res.body);
      List<dynamic> items = responseMap['data'] ?? [];
      List<SolarModel> results = [];

      for (var item in items) {
        results.add(SolarModel.fromJson(item));
      }
      return (results, null);
    } catch (e) {
      _log.e('Populating from Json failed with error: $e');

      var err = HttpError(
        error: e,
        response: res,
        type: HttpExceptionType.conversion,
      );
      return (null, err);
    }
  }
}

abstract class SolarRemoteDataSource {
  SolarRemoteDataSource(this.connection, this.endPoint);

  final RepoConfig connection;
  final String endPoint;

  Uri uri = Uri();

  Future<(List<SolarModel>?, HttpError?)> fetch({
    DateTime? date,
  });
}
