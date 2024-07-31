import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatusTvSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = GetWatchListStatusTvSeries(mockSeriesRepository);
  });

  test('should get watchlist status tv series from Repository', () async {
    when(mockSeriesRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
  });
}
