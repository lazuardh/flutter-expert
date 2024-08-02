import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingMoviesLoading());

      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) => emit(NowPlayingMoviesError(failure.message)),
        (list) {
          if (list.isEmpty) {
            emit(NowPlayingMoviesEmpty());
          } else {
            emit(NowPlayingMoviesHasData(list));
          }
        },
      );
    });
  }
}
