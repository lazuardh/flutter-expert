part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final List<TvSeries> list;

  WatchlistTvSeriesHasData(this.list);

  @override
  List<Object> get props => [list];
}

class AddedTvSeriesToWatchlist extends WatchlistTvSeriesState {
  final bool isAddedToWatchlist;

  AddedTvSeriesToWatchlist(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistTvSeriesMessage extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesMessage(this.message);

  @override
  List<Object> get props => [message];
}
