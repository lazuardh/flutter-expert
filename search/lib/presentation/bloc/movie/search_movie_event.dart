part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChangedMovies extends SearchMovieEvent {
  final String query;

  OnQueryChangedMovies(this.query);

  @override
  List<Object> get props => [query];
}
