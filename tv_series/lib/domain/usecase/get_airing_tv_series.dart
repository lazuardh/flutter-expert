import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetAiringTvSeries {
  final SeriesRepository repository;

  GetAiringTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getAiringTvSeries();
  }
}
