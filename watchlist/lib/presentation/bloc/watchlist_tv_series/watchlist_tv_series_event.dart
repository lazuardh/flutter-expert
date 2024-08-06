part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnGetTvSeriesWatchlist extends WatchlistTvSeriesEvent {}

class OnAddTvSeriesWatchlist extends WatchlistTvSeriesEvent {
  final TvSeriesDetail detail;

  OnAddTvSeriesWatchlist(this.detail);

  @override
  List<Object> get props => [detail];
}

class OnRemoveTvSeriesWatchlist extends WatchlistTvSeriesEvent {
  final TvSeriesDetail detail;

  OnRemoveTvSeriesWatchlist(this.detail);

  @override
  List<Object> get props => [detail];
}

class OnLoadedTvSeriesWatchlist extends WatchlistTvSeriesEvent {
  final int id;

  OnLoadedTvSeriesWatchlist(this.id);

  @override
  List<Object> get props => [id];
}
