import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';
import 'package:watchlist/watchlist.dart';

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
      context.read<GetAllWatchlistBloc>().add(OnLoadAllWathclist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<GetAllWatchlistBloc>().add(OnLoadAllWathclist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetAllWatchlistBloc, GetAllWatchlistState>(
          builder: (context, state) {
            if (state is GetAllWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetAllWatchlistHasData) {
              return ListView(
                children: [
                  ...state.movie.map((movie) => MovieCard(movie)),
                  ...state.tvSeries.map((tv) => TvSeriesCard(tv)),
                ],
              );
            } else if (state is GetAllWatchlistEmpty) {
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
