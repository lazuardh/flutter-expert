part of 'searchtvseries_bloc.dart';

abstract class SearchtvseriesState extends Equatable {
  const SearchtvseriesState();

  @override
  List<Object> get props => [];
}

class SearchtvseriesEmpty extends SearchtvseriesState {}

class SearchtvseriesLoading extends SearchtvseriesState {}

class SearchtvseriesError extends SearchtvseriesState {
  final String message;

  const SearchtvseriesError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchtvseriesHasData extends SearchtvseriesState {
  final List<TvSeries> result;

  const SearchtvseriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
