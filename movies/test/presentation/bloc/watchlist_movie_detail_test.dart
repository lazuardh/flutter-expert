import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_detail_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = WatchlistMovieBloc(
        getWatchlistMovies: mockGetWatchlistMovies,
        getWatchListStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist);
  });

  const watchlistAddSuccessMessage = 'Added to Watchlist';
  const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistMovieEmpty());
  });

  group('test for get watchlist Movies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, HasData] when get watchlist is successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieWatchlist()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [loading, Error] when get watchlist is unsuccessfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieWatchlist()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Empty] when wathclist is Empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));

        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieWatchlist()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieEmpty(),
      ],
    );
  });

  group('test for get watchlist status', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should get status [true] when wathclist status is true',
      build: () {
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);

        return bloc;
      },
      act: (bloc) => bloc.add(OnLoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        AddedMovieToWatchlist(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        return OnLoadWatchlistStatus(testMovieDetail.id).props;
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should get status [false] when wathclist status is false',
      build: () {
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);

        return bloc;
      },
      act: (bloc) => bloc.add(OnLoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        AddedMovieToWatchlist(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        return OnLoadWatchlistStatus(testMovieDetail.id).props;
      },
    );
  });

  group('test for add and remove Movies watchlist', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should update [Watchlist Status] when add watchlist is successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right(watchlistAddSuccessMessage));

        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);

        return bloc;
      },
      act: (bloc) => bloc.add(OnAddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMovieMessage(watchlistAddSuccessMessage),
        AddedMovieToWatchlist(true)
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return OnAddMovieToWatchlist(testMovieDetail).props;
      },
    );
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should throw [failure message status] when add watchlist is unsuccessfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnAddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMovieError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return OnAddMovieToWatchlist(testMovieDetail).props;
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should update [Watchlist Status] when removed watchlist is successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right(watchlistRemoveSuccessMessage));

        return bloc;
      },
      act: (bloc) => bloc.add(OnRemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMovieMessage(watchlistRemoveSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return OnRemoveMovieFromWatchlist(testMovieDetail).props;
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should throw [failure message status] when removed watchlist is unsuccessfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));

        return bloc;
      },
      act: (bloc) => bloc.add(OnRemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMovieError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return OnRemoveMovieFromWatchlist(testMovieDetail).props;
      },
    );
  });
}
