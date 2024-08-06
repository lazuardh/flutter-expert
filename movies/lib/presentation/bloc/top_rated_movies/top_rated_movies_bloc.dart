import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies})
      : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final list = await getTopRatedMovies.execute();

      list.fold(
        (failure) => emit(TopRatedMoviesError(failure.message)),
        (list) {
          if (list.isEmpty) {
            emit(TopRatedMoviesEmpty());
          } else {
            emit(TopRatedMoviesHasData(list));
          }
        },
      );
    });
  }
}
