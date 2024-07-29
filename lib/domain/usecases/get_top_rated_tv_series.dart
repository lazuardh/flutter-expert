import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import '../../common/failure.dart';
import '../repositories/series_repository.dart';

class GetTopRatedTvSeries {
  final SeriesRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
