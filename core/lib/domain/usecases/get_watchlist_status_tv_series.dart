import 'package:core/core.dart';

class GetWatchListStatusTvSeries {
  final SeriesRepository repository;

  GetWatchListStatusTvSeries(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
