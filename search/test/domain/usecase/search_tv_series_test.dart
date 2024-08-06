import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SearchTvSeries(mockSeriesRepository);
  });

  const tQuery = 'Hazbin Hotel';

  test('should get list of tv series from the repository', () async {
    when(mockSeriesRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(testSeriesList));

    final result = await usecase.execute(tQuery);
    expect(result, Right(testSeriesList));
  });
}
