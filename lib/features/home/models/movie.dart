import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Movie {
  final String? title;
  final String? posterPath;
  final String ?releaseDate;
  final String ?overview;
  final String ?uid;
  final double ?voteAverage;
  final int ?id;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    
  }) : uid = uuid.v4();

  // Factory constructor to create a Movie instance from a JSON map
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(id: json['id'],
        voteAverage: json['vote_average']??'Sorry there is no vote for this movie',
        title: json['title']??'Sorry there is no vote for this movie',
        posterPath: json['poster_path']??'Sorry there is no vote for this movie',
        overview: json['overview']??'Sorry there is no vote for this movie',
        releaseDate: json['release_date']??'Sorry there is no vote for this movie',
      );

  // Method to convert a Movie instance into a JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'overview': overview,
        'release_date': releaseDate,
        'vote_average': voteAverage,
      };
}
