import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:tv_series/tv_series.dart';

class SeriesListNotifier extends ChangeNotifier {
  var _getAiringTvSeries = <TvSeries>[];
  List<TvSeries> get airingTvSeries => _getAiringTvSeries;

  RequestState _airingTvState = RequestState.empty;
  RequestState get airingTvState => _airingTvState;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedSeriesState = RequestState.empty;
  RequestState get topRatedSeriesState => _topRatedSeriesState;

  String _message = '';
  String get message => _message;

  SeriesListNotifier({
    required this.getAiringTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  final GetAiringTvSeries getAiringTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchAiringTvSeries() async {
    _airingTvState = RequestState.loading;
    notifyListeners();

    final result = await getAiringTvSeries.execute();
    result.fold(
      (failure) {
        _airingTvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _airingTvState = RequestState.loaded;
        _getAiringTvSeries = seriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularSeries() async {
    _popularTvSeriesState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularTvSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _popularTvSeriesState = RequestState.loaded;
        _popularTvSeries = seriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedSeries() async {
    _topRatedSeriesState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _topRatedSeriesState = RequestState.loaded;
        _topRatedTvSeries = seriesData;
        notifyListeners();
      },
    );
  }
}
