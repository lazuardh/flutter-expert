import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetAiringTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late SeriesListNotifier provider;
  late MockGetAiringTvSeries mockGetAiringTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTvSeries = MockGetAiringTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = SeriesListNotifier(
      getAiringTvSeries: mockGetAiringTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tSeries = TvSeries(
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

  group('now airing tv series', () {
    test('initialState should be Empty', () {
      expect(provider.airingTvState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchAiringTvSeries();
      // assert
      verify(mockGetAiringTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchAiringTvSeries();
      // assert
      expect(provider.airingTvState, RequestState.loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchAiringTvSeries();
      // assert
      expect(provider.airingTvState, RequestState.loaded);
      expect(provider.airingTvSeries, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchAiringTvSeries();
      // assert
      expect(provider.airingTvState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchPopularSeries();
      // assert
      expect(provider.popularTvSeriesState, RequestState.loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change TvSeries data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchPopularSeries();
      // assert
      expect(provider.popularTvSeriesState, RequestState.loaded);
      expect(provider.popularTvSeries, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularSeries();
      // assert
      expect(provider.popularTvSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchTopRatedSeries();
      // assert
      expect(provider.topRatedSeriesState, RequestState.loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchTopRatedSeries();
      // assert
      expect(provider.topRatedSeriesState, RequestState.loaded);
      expect(provider.topRatedTvSeries, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedSeries();
      // assert
      expect(provider.topRatedSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
