import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/movies.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailEmpty()) {
    on<OnFetchMoviesDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final movieDetail = await getMovieDetail.execute(event.id);
      final recomendation = await getMovieRecommendations.execute(event.id);

      movieDetail.fold(
        (failure) {
          emit(MovieDetailError(message: failure.message));

          recomendation.fold(
            (failureRecom) =>
                emit(RecomendationError(message: failureRecom.message)),
            (_) => {},
          );
        },
        (movie) {
          recomendation.fold(
            (failure) => emit(RecomendationError(message: failure.message)),
            (recomendation) {
              if (recomendation.isEmpty) {
                emit(MovieDetailEmpty());
              } else {
                emit(MovieDetailHasData(movie, recomendation));
              }
            },
          );
        },
      );
    });
  }
}
