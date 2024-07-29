import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_table.dart';

import 'db/database_helper.dart';

abstract class SeriesLocalDataSource {
  Future<String> insertWatchlist(TVSeriesTable movie);
  Future<String> removeWatchlist(TVSeriesTable movie);
  Future<TVSeriesTable?> getTvSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistSeries();
}

class SeriesLocalDataSourceImpl extends SeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  SeriesLocalDataSourceImpl({
    required this.databaseHelper,
  });

  @override
  Future<TVSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    if (result != null) {
      return TVSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertWatchlist(TVSeriesTable series) async {
    try {
      await databaseHelper.insertWatchlistTvSeries(series);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVSeriesTable series) async {
    try {
      await databaseHelper.removeWatchlistTvSeries(series);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
