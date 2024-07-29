import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

import '../../common/failure.dart';
import '../repositories/series_repository.dart';

class GetWatchlistTvSeries {
  final SeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}
