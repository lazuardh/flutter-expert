import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesRecommendations {
  final SeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return repository.getTvSeriesRecommendations(id);
  }
}
