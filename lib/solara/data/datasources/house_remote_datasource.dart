import 'dart:convert';
import 'package:http/http.dart';
import '../../../core/util/repo_config.dart';
import '../../../core/resources/http_error.dart';
import '../../../core/util/logger.dart';
import '../models/house_model.dart';

class HouseRemoteDataSourceImpl extends HouseRemoteDataSource {
  HouseRemoteDataSourceImpl(RepoConfig connection, String endPoint)
      : super(connection, endPoint) {
    _endPointUrl = connection.baseUrl + endPoint;
  }

  late final String _endPointUrl;

  final _log = logger;

  @override
  Future<(List<HouseModel>?, HttpError?)> fetch({String? finder}) async {
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
      List<HouseModel> results = [];

      for (var item in items) {
        results.add(HouseModel.fromJson(item));
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

abstract class HouseRemoteDataSource {
  HouseRemoteDataSource(this.connection, this.endPoint);

  final RepoConfig connection;
  final String endPoint;

  Uri uri = Uri();

  Future<(List<HouseModel>?, HttpError?)> fetch({
    String? finder,
  });
}
