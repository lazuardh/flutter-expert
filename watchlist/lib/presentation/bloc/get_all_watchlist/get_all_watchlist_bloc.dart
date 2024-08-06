import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:watchlist/watchlist.dart';

part 'get_all_watchlist_event.dart';
part 'get_all_watchlist_state.dart';

class GetAllWatchlistBloc
    extends Bloc<GetAllWatchlistEvent, GetAllWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvSeries getWatchlistTvSeries;
  GetAllWatchlistBloc({
    required this.getWatchlistMovies,
    required this.getWatchlistTvSeries,
  }) : super(GetAllWatchlistEmpty()) {
    on<OnLoadAllWathclist>((event, emit) async {
      emit(GetAllWatchlistLoading());

      final movie = await getWatchlistMovies.execute();
      final tvSeries = await getWatchlistTvSeries.execute();

      movie.fold(
        (failure) {
          emit(GetWatchlistMovieError(failure.message));

          tvSeries.fold(
            (failure) => emit(GetWatchlistTvSeriesError(failure.message)),
            (_) => {},
          );
        },
        (movie) {
          tvSeries.fold(
            (failure) => emit(GetWatchlistTvSeriesError(failure.message)),
            (tvseries) {
              if (tvseries.isEmpty) {
                emit(GetAllWatchlistEmpty());
              } else {
                emit(GetAllWatchlistHasData(movie, tvseries));
              }
            },
          );
        },
      );
    });
  }
}
