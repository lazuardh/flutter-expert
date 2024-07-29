import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: "airDate",
    episodeCount: 5,
    id: 1,
    name: "name",
    overview: " overview",
    posterPath: "posterPath",
    seasonNumber: 1,
  );

  final tSeason = Season(
    airDate: "airDate",
    episodeCount: 5,
    id: 1,
    name: "name",
    overview: " overview",
    posterPath: "posterPath",
    seasonNumber: 1,
  );

  test("should be a class of Season entity", () {
    final results = tSeasonModel.toEntity();
    expect(results, tSeason);
  });
}
