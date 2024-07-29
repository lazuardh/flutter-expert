import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();

      Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
          .fetchWatchlistTvSeries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();

    Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
        .fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<WatchlistMovieNotifier, WatchlistTvSeriesNotifier>(
          builder: (context, movieData, tvSeriesData, child) {
            if (movieData.watchlistState == RequestState.Loading ||
                tvSeriesData.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (movieData.watchlistState == RequestState.Loaded ||
                tvSeriesData.watchlistState == RequestState.Loaded) {
              return ListView(
                children: [
                  ...movieData.watchlistMovies
                      .map((movie) => MovieCard(movie))
                      .toList(),
                  ...tvSeriesData.watchlistTvSeries
                      .map((tv) => TvSeriesCard(tv))
                      .toList(),
                ],
              );
              // ListView.builder(
              //   itemBuilder: (context, index) {
              //     final movie = movieData.watchlistMovies[index];
              //     return MovieCard(movie);
              //   },
              //   itemCount: movieData.watchlistMovies.length,
              // );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(movieData.message ?? tvSeriesData.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
