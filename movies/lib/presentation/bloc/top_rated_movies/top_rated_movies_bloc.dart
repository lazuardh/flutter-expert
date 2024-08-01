import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final list = await _getTopRatedMovies.execute();

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
