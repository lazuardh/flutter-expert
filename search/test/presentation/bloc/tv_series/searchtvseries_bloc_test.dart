import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv_series.dart';
import 'package:search/presentation/bloc/tv_series/searchtvseries_bloc.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'searchtvseries_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchtvseriesBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();

    bloc = SearchtvseriesBloc(mockSearchTvSeries);
  });

  final tQuery = 'Hazbin Hotel';

  test('initial state should be empty', () {
    expect(bloc.state, SearchtvseriesEmpty());
  });

  blocTest<SearchtvseriesBloc, SearchtvseriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(testSeriesList));

      return bloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedTvseries(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchtvseriesLoading(),
      SearchtvseriesHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchtvseriesBloc, SearchtvseriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );

      return bloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedTvseries(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchtvseriesLoading(),
      const SearchtvseriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
