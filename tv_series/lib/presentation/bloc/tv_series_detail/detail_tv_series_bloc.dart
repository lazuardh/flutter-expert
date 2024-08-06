import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_series/tv_series.dart';

part 'detail_tv_series_event.dart';
part 'detail_tv_series_state.dart';

class DetailTvSeriesBloc
    extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
  }) : super(DetailTvSeriesEmpty()) {
    on<OnFetchTvSeriesDetail>((event, emit) async {
      emit(DetailTvSeriesLoading());

      final tvSeries = await getTvSeriesDetail.execute(event.id);
      final recommendation = await getTvSeriesRecommendations.execute(event.id);

      tvSeries.fold(
        (failure) {
          emit(DetailTvSeriesError(failure.message));

          recommendation.fold(
            (l) => emit(RecommendationError(failure.message)),
            (_) => {},
          );
        },
        (tvSeries) {
          recommendation.fold(
            (failure) => emit(RecommendationError(failure.message)),
            (recommendation) {
              recommendation.isEmpty
                  ? emit(DetailTvSeriesEmpty())
                  : emit(DetailTvSeriesHasData(tvSeries, recommendation));
            },
          );
        },
      );
    });
  }
}
