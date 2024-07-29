import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    notifier = PopularTvSeriesNotifier(mockGetPopularTvSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tSeries = TvSeries(
    posterPath: '/path.jpg',
    popularity: 2.3,
    id: 1,
    backdropPath: '/path.jpg',
    voteAverage: 8.0,
    overview: 'Overview',
    firstAirDate: '2022-10-10',
    originCountry: ['en', 'id'],
    genreIds: [1, 2, 3],
    originalLanguage: 'Original Language',
    voteCount: 230,
    name: 'Name',
    originalName: 'Original Name',
  );

  final tSeriesList = <TvSeries>[tSeries];

  test('should change state to loading when usecase is called', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tSeriesList));

    notifier.fetchPopularSeries();

    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tSeriesList));

    await notifier.fetchPopularSeries();

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvSeries, tSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await notifier.fetchPopularSeries();

    expect(notifier.state, RequestState.Error);
    expect(notifier.message, "Server Failure");
    expect(listenerCallCount, 2);
  });
}
