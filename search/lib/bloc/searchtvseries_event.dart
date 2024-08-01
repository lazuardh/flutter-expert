part of 'searchtvseries_bloc.dart';

abstract class SearchtvseriesEvent extends Equatable {
  const SearchtvseriesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchtvseriesEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
