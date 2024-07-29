import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import '../../common/failure.dart';
import '../repositories/series_repository.dart';

class SaveTvSeriesToWatchlist {
  final SeriesRepository repository;

  SaveTvSeriesToWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail series) {
    return repository.saveWatchlist(series);
  }
}
