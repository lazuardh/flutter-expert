import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:provider/provider.dart';

class BlocWatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-bloc';

  const BlocWatchlistPage({super.key});

  @override
  _BlocWatchlistPageState createState() => _BlocWatchlistPageState();
}

class _BlocWatchlistPageState extends State<BlocWatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(OnGetMovieWatchlist());

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
    context.read<WatchlistMovieBloc>().add(OnGetMovieWatchlist());

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
        child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
          builder: (context, movie) {
            if (movie is WatchlistMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (movie is WatchlistMovieHasData) {
              return ListView(
                children: [
                  ...movie.list.map((movie) => MovieCard(movie)),
                  // ...tvSeriesData.watchlistTvSeries
                  //     .map((tv) => TvSeriesCard(tv)),
                ],
              );
            } else if (movie is WatchlistMovieEmpty) {
              return const Center(
                child: Text('Empty Watchlist'),
              );
            } else {
              return const Center(
                key: Key('error_message'),
                child: Text('Failed'),
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
