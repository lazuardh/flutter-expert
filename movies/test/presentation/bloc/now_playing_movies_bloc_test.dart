import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMoviesBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, HasData] when list data gotten is successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovie()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, Error] when get data gotten is unsuccessfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovie()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, Empty]',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovie()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesEmpty(),
    ],
  );
}
