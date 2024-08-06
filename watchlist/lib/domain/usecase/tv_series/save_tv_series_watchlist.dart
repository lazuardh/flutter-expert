import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class SaveTvSeriesToWatchlist {
  final SeriesRepository repository;

  SaveTvSeriesToWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail series) {
    return repository.saveWatchlist(series);
  }
}
