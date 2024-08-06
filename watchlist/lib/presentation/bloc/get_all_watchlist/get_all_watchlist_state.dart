part of 'get_all_watchlist_bloc.dart';

abstract class GetAllWatchlistState extends Equatable {
  const GetAllWatchlistState();

  @override
  List<Object> get props => [];
}

class GetAllWatchlistEmpty extends GetAllWatchlistState {}

class GetAllWatchlistLoading extends GetAllWatchlistState {}

class GetWatchlistMovieError extends GetAllWatchlistState {
  final String message;

  GetWatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistTvSeriesError extends GetAllWatchlistState {
  final String message;

  GetWatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetAllWatchlistHasData extends GetAllWatchlistState {
  final List<Movie> movie;
  final List<TvSeries> tvSeries;

  GetAllWatchlistHasData(this.movie, this.tvSeries);

  @override
  List<Object> get props => [movie, tvSeries];
}
