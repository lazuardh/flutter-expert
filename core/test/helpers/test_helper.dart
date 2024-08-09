import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  SeriesRepository,
  MovieRemoteDataSource,
  SeriesRemoteDataSource,
  MovieLocalDataSource,
  SeriesLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
