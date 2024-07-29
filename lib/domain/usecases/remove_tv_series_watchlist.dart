import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series_detail.dart';

import '../repositories/series_repository.dart';

class RemoveTvSeriesWatchlist {
  final SeriesRepository repository;

  RemoveTvSeriesWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail series) {
    return repository.removeWatchlist(series);
  }
}
