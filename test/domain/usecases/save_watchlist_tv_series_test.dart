import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesToWatchlist usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SaveTvSeriesToWatchlist(mockSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    when(mockSeriesRepository.saveWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));

    final result = await usecase.execute(testTvSeriesDetail);
    expect(result, Right('Added to Watchlist'));
  });
}
