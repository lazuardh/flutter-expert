import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class RemoveTvSeriesWatchlist {
  final SeriesRepository repository;

  RemoveTvSeriesWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail series) {
    return repository.removeWatchlist(series);
  }
}
