import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_series/tv_series.dart';

part 'now_playing_tv_series_event.dart';
part 'now_playing_tv_series_state.dart';

class NowPlayingTvSeriesBloc
    extends Bloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState> {
  final GetAiringTvSeries _getAiringTvSeries;

  NowPlayingTvSeriesBloc(this._getAiringTvSeries)
      : super(NowPlayingTvSeriesEmpty()) {
    on<OnFetchNowPlayingTvSeries>((event, emit) async {
      emit(NowPlayingTvSeriesLoading());

      final result = await _getAiringTvSeries.execute();

      result.fold(
        (failure) => emit(NowPlayingTvSeriesError(failure.message)),
        (list) {
          list.isEmpty
              ? emit(NowPlayingTvSeriesEmpty())
              : emit(NowPlayingTvSeriesHasData(list));
        },
      );
    });
  }
}
