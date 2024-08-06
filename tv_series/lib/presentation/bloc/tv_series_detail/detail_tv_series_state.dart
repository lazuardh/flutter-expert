part of 'detail_tv_series_bloc.dart';

abstract class DetailTvSeriesState extends Equatable {
  const DetailTvSeriesState();

  @override
  List<Object> get props => [];
}

class DetailTvSeriesEmpty extends DetailTvSeriesState {}

class DetailTvSeriesLoading extends DetailTvSeriesState {}

class DetailTvSeriesError extends DetailTvSeriesState {
  final String message;

  DetailTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailTvSeriesHasData extends DetailTvSeriesState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recomendation;

  DetailTvSeriesHasData(this.tvSeries, this.recomendation);

  @override
  List<Object> get props => [tvSeries, recomendation];
}

class RecommendationError extends DetailTvSeriesState {
  final String message;

  RecommendationError(this.message);

  @override
  List<Object> get props => [message];
}
