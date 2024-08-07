import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListStatusTvSeries,
  SaveTvSeriesToWatchlist,
  RemoveTvSeriesWatchlist,
])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveTvSeriesToWatchlist mockSaveTvSeriesToWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveTvSeriesToWatchlist = MockSaveTvSeriesToWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    bloc = WatchlistTvSeriesBloc(
        getWatchlistTvSeries: mockGetWatchlistTvSeries,
        getWatchListStatusTvSeries: mockGetWatchListStatusTvSeries,
        saveTvSeriesWatchlist: mockSaveTvSeriesToWatchlist,
        removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist);
  });

  const watchlistAddSuccessMessage = 'Added to Watchlist';
  const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvSeriesEmpty());
  });

  group('test for get watchlist Movies', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, HasData] when get watchlist is successfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testSeriesList));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvSeriesWatchlist()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesHasData(testSeriesList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [loading, Error] when get watchlist is unsuccessfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvSeriesWatchlist()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, Empty] when wathclist is Empty',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Right([]));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvSeriesWatchlist()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesEmpty(),
      ],
    );
  });

  group('test for get watchlist status', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should get status [true] when wathclist status is true',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);

        return bloc;
      },
      act: (bloc) => bloc.add(OnLoadedTvSeriesWatchlist(testTvSeriesDetail.id)),
      expect: () => [
        AddedTvSeriesToWatchlist(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
        return OnLoadedTvSeriesWatchlist(testTvSeriesDetail.id).props;
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should get status [false] when wathclist status is false',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);

        return bloc;
      },
      act: (bloc) => bloc.add(OnLoadedTvSeriesWatchlist(testTvSeriesDetail.id)),
      expect: () => [
        AddedTvSeriesToWatchlist(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
        return OnLoadedTvSeriesWatchlist(testTvSeriesDetail.id).props;
      },
    );
  });

  group('test for add and remove Movies watchlist', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should update [Watchlist Status] when add watchlist is successfully',
      build: () {
        when(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right(watchlistAddSuccessMessage));

        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);

        return bloc;
      },
      act: (bloc) => bloc.add(OnAddTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesMessage(watchlistAddSuccessMessage),
        AddedTvSeriesToWatchlist(true)
      ],
      verify: (bloc) {
        verify(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail));
        return OnAddTvSeriesWatchlist(testTvSeriesDetail).props;
      },
    );
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should throw [failure message status] when add watchlist is unsuccessfully',
      build: () {
        when(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async =>
                const Left(DatabaseFailure('can\'t add data to watchlist')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnAddTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveTvSeriesToWatchlist.execute(testTvSeriesDetail));
        return OnAddTvSeriesWatchlist(testTvSeriesDetail).props;
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should update [Watchlist Status] when removed watchlist is successfully',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right(watchlistRemoveSuccessMessage));

        return bloc;
      },
      act: (bloc) => bloc.add(OnRemoveTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesMessage(watchlistRemoveSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail));
        return OnRemoveTvSeriesWatchlist(testTvSeriesDetail).props;
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should throw [failure message status] when removed watchlist is unsuccessfully',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async =>
                Left(DatabaseFailure('can\'t add data to watchlist')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnRemoveTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail));
        return OnRemoveTvSeriesWatchlist(testTvSeriesDetail).props;
      },
    );
  });
}
