part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class OnGetMovieWatchlist extends WatchlistMovieEvent {}

class OnLoadWatchlistStatus extends WatchlistMovieEvent {
  final int id;

  OnLoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddMovieToWatchlist extends WatchlistMovieEvent {
  final MovieDetail detail;

  OnAddMovieToWatchlist(this.detail);

  @override
  List<Object> get props => [detail];
}

class OnRemoveMovieFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail detail;

  OnRemoveMovieFromWatchlist(this.detail);

  @override
  List<Object> get props => [detail];
}
