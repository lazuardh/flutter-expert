import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesNotifier])
void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final mockNotifier = MockPopularMoviesNotifier();
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(
      ChangeNotifierProvider<PopularMoviesNotifier>.value(
        value: mockNotifier,
        child: _makeTestableWidget(PopularMoviesPage()),
      ),
    );

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final mockNotifier = MockPopularMoviesNotifier();
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.movies).thenReturn(<Movie>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(ChangeNotifierProvider<PopularMoviesNotifier>.value(
      value: mockNotifier,
      child: _makeTestableWidget(PopularMoviesPage()),
    ));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final mockNotifier = MockPopularMoviesNotifier();
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(ChangeNotifierProvider<PopularMoviesNotifier>.value(
      value: mockNotifier,
      child: _makeTestableWidget(PopularMoviesPage()),
    ));

    expect(textFinder, findsOneWidget);
  });
}