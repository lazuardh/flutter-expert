import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  const tId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieDetailBloc(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations);
  });

  test('intial state should be empty', () {
    expect(bloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, hasData] when list data gotten is successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(testMovieDetail, testMovieList)
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, Error] when get data gotten is unsuccessfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError(message: 'Server Failure'),
      RecomendationError(message: 'Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit recomendation is  [Loading, empty]',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailEmpty(),
    ],
  );
}
