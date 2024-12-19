import 'dart:convert';
import 'package:http/http.dart';
import '../../../core/util/repo_config.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/util/logger.dart';
import '../models/battery_model.dart';

class BatteryRemoteDataSourceImpl extends BatteryRemoteDataSource {
  BatteryRemoteDataSourceImpl(RepoConfig connection, String path)
      : super(connection, path) {
    _url = connection.baseUrl + path;
  }

  late final String _url;

  final _log = logger;

  @override
  Future<(List<BatteryModel>?, HttpError?)> fetch({DateTime? date}) async {
    String endPointUrl = _url;
    final params = <String, String>{};

    uri = Uri.parse(endPointUrl);

    if (date != null) {
      params['date'] = date.toIso8601String();
    }

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
      List<dynamic> items = json.decode(res.body);
      List<BatteryModel> results = [];

      for (var item in items) {
        results.add(BatteryModel.fromJson(item));
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

abstract class BatteryRemoteDataSource {
  BatteryRemoteDataSource(this.connection, this.endPoint);

  final RepoConfig connection;
  final String endPoint;

  Uri uri = Uri();

  Future<(List<BatteryModel>?, HttpError?)> fetch({
    DateTime? date,
  });
}
