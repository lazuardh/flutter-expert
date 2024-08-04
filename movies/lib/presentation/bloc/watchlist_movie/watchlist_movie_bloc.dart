import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  // static const watchlistAddSuccessMessage = 'Added to Watchlist';
  // static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMovieEmpty()) {
    on<OnGetMovieWatchlist>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMovieEmpty());
          } else {
            emit(WatchlistMovieHasData(data));
          }
        },
      );
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(AddedMovieToWatchlist(status));
    });

    on<OnAddMovieToWatchlist>((event, emit) async {
      final movie = await saveWatchlist.execute(event.detail);

      movie.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (message) {
          emit(WatchlistMovieMessage(message));
          //refresh status
          add(OnLoadWatchlistStatus(event.detail.id));
        },
      );
    });

    on<OnRemoveMovieFromWatchlist>((event, emit) async {
      final delete = await removeWatchlist.execute(event.detail);

      delete.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (message) {
          emit(WatchlistMovieMessage(message));
          // //refresh status
          // add(OnLoadWatchlistStatus(event.detail.id));
        },
      );
    });
  }
}
