import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc bloc;

  setUp(() {
    bloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(TopRatedMoviesLoading());
    when(bloc.stream).thenAnswer((_) => Stream.value(TopRatedMoviesLoading()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(TopRatedMoviesHasData(testMovieList));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesHasData(testMovieList)));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(TopRatedMoviesError('Data Not Found'));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesError('Data Not Found')));

    final textFinder = find.byKey(const Key('error_message'));
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
