import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc getBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    getBloc = TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
  });

  test('initial state should be empty', () {
    expect(getBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [loading, hasData] when list data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      return getBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Error] when get list data is unsuccessfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return getBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Empty] when data is Empty',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Right([]));

      return getBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesEmpty(),
    ],
  );
}
