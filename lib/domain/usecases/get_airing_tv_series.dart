import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import '../../common/failure.dart';
import '../repositories/series_repository.dart';

class GetAiringTvSeries {
  final SeriesRepository repository;

  GetAiringTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getAiringTvSeries();
  }
}
