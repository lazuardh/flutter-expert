part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError({
    required this.message,
  });
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recomendation;

  MovieDetailHasData(this.movie, this.recomendation);

  @override
  List<Object> get props => [movie, recomendation];
}

class RecomendationError extends MovieDetailState {
  final String message;

  const RecomendationError({required this.message});

  @override
  List<Object> get props => [message];
}
