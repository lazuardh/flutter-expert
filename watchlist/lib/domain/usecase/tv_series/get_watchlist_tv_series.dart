import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetWatchlistTvSeries {
  final SeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}
