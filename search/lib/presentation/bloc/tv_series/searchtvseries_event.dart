part of 'searchtvseries_bloc.dart';

abstract class SearchtvseriesEvent extends Equatable {
  const SearchtvseriesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChangedTvseries extends SearchtvseriesEvent {
  final String query;

  OnQueryChangedTvseries(this.query);

  @override
  List<Object> get props => [query];
}
