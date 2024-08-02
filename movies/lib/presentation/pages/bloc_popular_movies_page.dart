import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';

class BlocPopularMoviesPage extends StatefulWidget {
  const BlocPopularMoviesPage({super.key});

  @override
  State<BlocPopularMoviesPage> createState() => _BlocPopularMoviesPageState();
}

class _BlocPopularMoviesPageState extends State<BlocPopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularMoviesBloc>().add(FetchPopularMovies()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          builder: (context, state) {
            if (state is PopularMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMoviesHasData) {
              final result = state.list;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is PopularMoviesError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text("Data Not Found"),
              );
            }
          },
        ),
      ),
    );
  }
}
