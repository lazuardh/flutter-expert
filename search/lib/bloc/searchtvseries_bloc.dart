import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helper/event_transformer.dart';

part 'searchtvseries_event.dart';
part 'searchtvseries_state.dart';

class SearchtvseriesBloc
    extends Bloc<SearchtvseriesEvent, SearchtvseriesState> {
  final SearchTvSeries _searchTvSeries;

  SearchtvseriesBloc(this._searchTvSeries) : super(SearchtvseriesEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        emit(SearchtvseriesLoading());

        final result = await _searchTvSeries.execute(query);

        result.fold(
          (failure) => emit(SearchtvseriesError(failure.message)),
          (data) => emit(SearchtvseriesHasData(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
