import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../test/helpers/test_helper.mocks.dart';
import '../../dummy_data/tv_series/dummy_objects.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockSeriesRepository mockSeriesRepository;
  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = GetWatchlistTvSeries(mockSeriesRepository);
  });

  test('should get list of Tv Series from the repository', () async {
    // arrange
    when(mockSeriesRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(testSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testSeriesList));
  });
}
