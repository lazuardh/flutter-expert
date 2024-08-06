import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:watchlist/watchlist.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final SaveTvSeriesToWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
    required this.getWatchListStatusTvSeries,
    required this.saveTvSeriesWatchlist,
    required this.removeTvSeriesWatchlist,
  }) : super(WatchlistTvSeriesEmpty()) {
    on<OnGetTvSeriesWatchlist>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) {
          data.isEmpty
              ? emit(WatchlistTvSeriesEmpty())
              : emit(WatchlistTvSeriesHasData(data));
        },
      );
    });

    on<OnAddTvSeriesWatchlist>((event, emit) async {
      final tvSeries = await saveTvSeriesWatchlist.execute(event.detail);

      tvSeries.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (message) {
          emit(WatchlistTvSeriesMessage(message));
        },
      );
    });

    on<OnRemoveTvSeriesWatchlist>((event, emit) async {
      final delete = await removeTvSeriesWatchlist.execute(event.detail);

      delete.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesMessage(data)),
      );
    });

    on<OnLoadedTvSeriesWatchlist>((event, emit) async {
      final status = await getWatchListStatusTvSeries.execute(event.id);
      emit(AddedTvSeriesToWatchlist(status));
    });
  }
}
