import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';

class BlocTopRatedMoviesPage extends StatefulWidget {
  const BlocTopRatedMoviesPage({super.key});

  @override
  State<BlocTopRatedMoviesPage> createState() => _BlocTopRatedMoviesPageState();
}

class _BlocTopRatedMoviesPageState extends State<BlocTopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies()),
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
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is TopRatedMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMoviesHasData) {
              final result = state.list;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is TopRatedMoviesError) {
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
