import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/tv_series/dummy_objects.dart';
import 'get_all_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTvSeries])
void main() {
  late GetAllWatchlistBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = GetAllWatchlistBloc(
        getWatchlistMovies: mockGetWatchlistMovies,
        getWatchlistTvSeries: mockGetWatchlistTvSeries);
  });

  test('initial state should be empty', () {
    expect(bloc.state, GetAllWatchlistEmpty());
  });

  blocTest<GetAllWatchlistBloc, GetAllWatchlistState>(
    'should emit [Loading, HasData] when get watchlist is successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));

      return bloc;
    },
    act: (bloc) => bloc.add(OnLoadAllWathclist()),
    expect: () => [
      GetAllWatchlistLoading(),
      GetAllWatchlistHasData(testMovieList, testSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<GetAllWatchlistBloc, GetAllWatchlistState>(
    'should emit [loading, Error] when get watchlist is unsuccessfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnLoadAllWathclist()),
    expect: () => [
      GetAllWatchlistLoading(),
      GetWatchlistMovieError('Server Failure'),
      GetWatchlistTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<GetAllWatchlistBloc, GetAllWatchlistState>(
    'should emit [Loading, Empty] when wathclist is Empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right([]));

      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnLoadAllWathclist()),
    expect: () => [
      GetAllWatchlistLoading(),
      GetAllWatchlistEmpty(),
    ],
  );
}
