import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:solara/core/resources/solara_io_exception.dart';
import 'package:solara/core/util/repo_config.dart';
import 'package:solara/solara/data/datasources/solar_remote_datasource.dart';
import 'package:solara/solara/data/models/solar_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  final mockHttpClient = MockHttpClient();
  final mockResponse = MockResponse();
  final repoConfig = RepoConfig(baseUrl: '', client: mockHttpClient);
  final SolarRemoteDataSourceImpl solarRemoteDataSourceImpl =
      SolarRemoteDataSourceImpl(repoConfig, '');

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('SolarRemoteDataSourceImpl.fetch() success', () {
    final List<SolarModel> solarModels = [];
    setUp(() async {
      solarModels.clear();
      solarModels.add(SolarModel.fromJson(
          {'timestamp': '2024-12-21T20:56:00.467Z', 'value': 3630}));
      solarModels.add(SolarModel.fromJson(
          {'timestamp': '2025-12-21T20:56:00.467Z', 'value': 3000}));
      solarModels.add(SolarModel.fromJson(
          {'timestamp': '2026-12-21T20:56:00.467Z', 'value': 4000}));

      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(jsonEncode([
        for (var solarModel in solarModels) ...[solarModel.toJson()]
      ]));
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
    });

    test('SolarRemoteDataSourceImpl fetch multiple', () async {
      final (result, err) = await solarRemoteDataSourceImpl.fetch();

      expect(result, isNotNull);
      expect(err, isNull);
      expect(result!.length, solarModels.length);

      for (int i = 0; i != solarModels.length; ++i) {
        expect(result[i] == solarModels[i], true);
      }
    });
  });

  group('SolarRemoteDataSourceImpl.fetch() fail', () {
    setUp(() async {
      when(() => mockResponse.body).thenReturn('[]');
    });

    test('SolarRemoteDataSourceImpl failure status code', () async {
      when(() => mockResponse.statusCode).thenReturn(500);
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);

      final (result, err) = await solarRemoteDataSourceImpl.fetch();
      expect(result, isNull);
      expect(err, isNotNull);
      expect(err!.type == IOExceptionType.server, true);
    });

    test('SolarRemoteDataSourceImpl empty response', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => MockResponse());

      final (result, err) = await solarRemoteDataSourceImpl.fetch();
      expect(result, isNull);
      expect(err, isNotNull);
      expect(err!.type == IOExceptionType.other, true);
    });

    test('SolarRemoteDataSourceImpl no response body on error', () async {
      when(() => mockResponse.body).thenReturn('');
      when(() => mockResponse.statusCode).thenReturn(500);
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);

      final (result, err) = await solarRemoteDataSourceImpl.fetch();
      expect(result, isNull);
      expect(err, isNotNull);
      expect(err!.type == IOExceptionType.other, true);
    });
  });
}
