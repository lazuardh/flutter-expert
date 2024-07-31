import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

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

  @override
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
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<WatchlistMovieNotifier, WatchlistTvSeriesNotifier>(
          builder: (context, movieData, tvSeriesData, child) {
            if (movieData.watchlistState == RequestState.loading ||
                tvSeriesData.watchlistState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (movieData.watchlistState == RequestState.loaded ||
                tvSeriesData.watchlistState == RequestState.loaded) {
              return ListView(
                children: [
                  ...movieData.watchlistMovies.map((movie) => MovieCard(movie)),
                  ...tvSeriesData.watchlistTvSeries
                      .map((tv) => TvSeriesCard(tv)),
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
                key: const Key('error_message'),
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
