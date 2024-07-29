import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = GetTvSeriesDetail(mockSeriesRepository);
  });

  final tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockSeriesRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvSeriesDetail));
  });
}
