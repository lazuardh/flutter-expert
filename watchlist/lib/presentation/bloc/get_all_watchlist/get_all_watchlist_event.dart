part of 'get_all_watchlist_bloc.dart';

abstract class GetAllWatchlistEvent extends Equatable {
  const GetAllWatchlistEvent();

  @override
  List<Object> get props => [];
}

class OnLoadAllWathclist extends GetAllWatchlistEvent {}
