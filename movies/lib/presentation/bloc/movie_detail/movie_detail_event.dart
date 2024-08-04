part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFetchMoviesDetail extends MovieDetailEvent {
  final int id;

  OnFetchMoviesDetail(this.id);

  @override
  List<Object> get props => [id];
}
