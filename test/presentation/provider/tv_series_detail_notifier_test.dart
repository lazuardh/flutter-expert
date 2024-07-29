import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveTvSeriesToWatchlist,
  RemoveTvSeriesWatchlist,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchlistStatusTvSeries;
  late MockSaveTvSeriesToWatchlist mockSaveTvSeriesToWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveTvSeriesToWatchlist = MockSaveTvSeriesToWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatusTvSeries: mockGetWatchlistStatusTvSeries,
      saveTvSeriesToWatchlist: mockSaveTvSeriesToWatchlist,
      removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;
  final tTvSeries = <TvSeries>[testTvSeries];

  void _arrangeUsecase() {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvSeries));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesDetail.execute(tId));
      verify(mockGetTvSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.tvSeries, testTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTvSeries);
    });
  });

  group('Get Tv Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(tId));
      expect(provider.tvSeriesRecommendations, tTvSeries);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTvSeries);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatusTvSeries.execute(1))
          .thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTvSeriesToWatchlist(testTvSeriesDetail);
      // assert
      verify(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeTvSeriesFromWatchlist(testTvSeriesDetail);
      // assert
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTvSeriesToWatchlist(testTvSeriesDetail);
      // assert
      verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addTvSeriesToWatchlist(testTvSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvSeries));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
