import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';
import 'package:watchlist/watchlist.dart';

class BlocWatchlistPage extends StatefulWidget {
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
      context.read<WatchlistTvSeriesBloc>().add(OnGetTvSeriesWatchlist());
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
    context.read<WatchlistTvSeriesBloc>().add(OnGetTvSeriesWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    final statemovie = context.watch<WatchlistMovieBloc>().state;
    final statetvseries = context.watch<WatchlistTvSeriesBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: statemovie is WatchlistMovieEmpty &&
                statetvseries is WatchlistTvSeriesEmpty
            ? const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_off_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('No watchlist available'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                      builder: (context, state) {
                        if (state is WatchlistMovieLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistMovieHasData) {
                          return Visibility(
                            visible: state.list.isNotEmpty,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return MovieCard(state.list[index]);
                              },
                              itemCount: state.list.length,
                            ),
                          );
                        } else if (state is WatchlistMovieEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return const Center(
                            key: Key('error_message'),
                            child: Text('Failed'),
                          );
                        }
                      },
                    ),
                    BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
                      builder: (context, state) {
                        if (state is WatchlistTvSeriesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistTvSeriesHasData) {
                          return Visibility(
                            visible: state.list.isNotEmpty,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return TvSeriesCard(state.list[index]);
                              },
                              itemCount: state.list.length,
                            ),
                          );
                        } else if (state is WatchlistTvSeriesEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return const Center(
                            key: Key('error_message'),
                            child: Text('Failed'),
                          );
                        }
                      },
                    ),
                  ],
                ),
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
