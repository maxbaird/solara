import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/util/repo_config.dart';
import 'package:http/http.dart' as http;
import 'package:solara/solara/data/datasources/battery_remote_datasource.dart';
import 'package:solara/solara/data/models/battery_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  final mockHttpClient = MockHttpClient();
  final mockResponse = MockResponse();
  final repoConfig = RepoConfig(baseUrl: '', client: mockHttpClient);
  final BatteryRemoteDataSourceImpl batteryRemoteDataSourceImpl =
      BatteryRemoteDataSourceImpl(repoConfig, '');

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('BatteryRemoteDataSourceImpl.fetch()', () {
    setUp(() async {
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(jsonEncode([
        {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630}
      ]));
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
    });

    test('test fetch', () async {
      final (result, err) = await batteryRemoteDataSourceImpl.fetch(
          date: DateTime.parse('2024-12-21T20:56:00.467Z'));

      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, 1);
      expect(
          result.first ==
              BatteryModel.fromJson(
                  {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630}),
          true);
    });
  });
}
