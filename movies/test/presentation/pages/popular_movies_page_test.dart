import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('PopularMoviesPage', () {
    testWidgets('displays a progress bar when loading',
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(PopularMoviesLoading());
      when(mockBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMoviesLoading()));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('displays a ListView when data is loaded',
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(PopularMoviesHasData(testMovieList));
      when(mockBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMoviesHasData(testMovieList)));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays an error message when there is an error',
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(PopularMoviesError('Data Not Found'));
      when(mockBloc.stream).thenAnswer(
          (_) => Stream.value(PopularMoviesError('Data Not Found')));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(find.byType(Center), findsOneWidget);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });
}
