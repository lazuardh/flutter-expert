import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import 'detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail, GetTvSeriesRecommendations])
void main() {
  late DetailTvSeriesBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  const tId = 1;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    bloc = DetailTvSeriesBloc(
        getTvSeriesDetail: mockGetTvSeriesDetail,
        getTvSeriesRecommendations: mockGetTvSeriesRecommendations);
  });

  test('intial state should be empty', () {
    expect(bloc.state, DetailTvSeriesEmpty());
  });

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit [Loading, hasData] when list data gotten is successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));

      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testSeriesList));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvSeriesDetail(tId)),
    expect: () => [
      DetailTvSeriesLoading(),
      DetailTvSeriesHasData(testTvSeriesDetail, testSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
      verify(mockGetTvSeriesRecommendations.execute(tId));
    },
  );

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit [Loading, Error] when get data gotten is unsuccessfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvSeriesDetail(tId)),
    expect: () => [
      DetailTvSeriesLoading(),
      DetailTvSeriesError('Server Failure'),
      RecommendationError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
      verify(mockGetTvSeriesRecommendations.execute(tId));
    },
  );

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit recomendation is  [Loading, empty]',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));

      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvSeriesDetail(tId)),
    expect: () => [
      DetailTvSeriesLoading(),
      DetailTvSeriesEmpty(),
    ],
  );
}
