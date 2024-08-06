import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTvSeries])
void main() {
  late NowPlayingTvSeriesBloc bloc;
  late MockGetAiringTvSeries getAiringTvSeries;

  setUp(() {
    getAiringTvSeries = MockGetAiringTvSeries();
    bloc = NowPlayingTvSeriesBloc(getAiringTvSeries);
  });

  test('initial state should be empty', () {
    expect(bloc.state, NowPlayingTvSeriesEmpty());
  });

  blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
    'should emit [Loading, HasData] when list data gotten is successfully',
    build: () {
      when(getAiringTvSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingTvSeries()),
    expect: () => [
      NowPlayingTvSeriesLoading(),
      NowPlayingTvSeriesHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(getAiringTvSeries.execute());
    },
  );

  blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
    'should emit [Loading, Error] when list data gotten is unsuccessfully',
    build: () {
      when(getAiringTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingTvSeries()),
    expect: () => [
      NowPlayingTvSeriesLoading(),
      NowPlayingTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(getAiringTvSeries.execute());
    },
  );

  blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
    'should emit [Loading, Empty] when data gotten is EMpty',
    build: () {
      when(getAiringTvSeries.execute())
          .thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingTvSeries()),
    expect: () => [
      NowPlayingTvSeriesLoading(),
      NowPlayingTvSeriesEmpty(),
    ],
  );
}
