import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc, WatchlistMovieBloc])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailBloc.stream).thenAnswer((_) =>
        Stream.value(MovieDetailHasData(testMovieDetail, testMovieList)));
    when(mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail, testMovieList));
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value(AddedMovieToWatchlist(false)));
    when(mockWatchlistMovieBloc.state).thenReturn(AddedMovieToWatchlist(false));

    await tester.pumpWidget(
        makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailBloc.stream).thenAnswer((_) =>
        Stream.value(MovieDetailHasData(testMovieDetail, testMovieList)));
    when(mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail, testMovieList));
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value(AddedMovieToWatchlist(true)));
    when(mockWatchlistMovieBloc.state).thenReturn(AddedMovieToWatchlist(true));

    await tester.pumpWidget(
        makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailBloc.stream).thenAnswer((_) =>
        Stream.value(MovieDetailHasData(testMovieDetail, testMovieList)));
    when(mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail, testMovieList));
    when(mockWatchlistMovieBloc.stream).thenAnswer(
        (_) => Stream.value(WatchlistMovieMessage('Added to Watchlist')));
    when(mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieMessage('Added to Watchlist'));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final watchlistButton = find.byType(ElevatedButton);

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
