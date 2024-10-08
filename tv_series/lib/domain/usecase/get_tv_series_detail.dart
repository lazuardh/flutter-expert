import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesDetail {
  final SeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
