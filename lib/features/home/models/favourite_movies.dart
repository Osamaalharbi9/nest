import 'package:nest/features/home/models/movie.dart';

class FavouriteMoviesState {
  final Set<Movie> movies;
   bool movieExists;

  FavouriteMoviesState({
    required this.movies,
    required this.movieExists,
  });

  FavouriteMoviesState copyWith({
    Set<Movie>? movies,
    bool? movieExists,
  }) {
    return FavouriteMoviesState(
      movies: movies ?? this.movies,
      movieExists: movieExists ?? this.movieExists,
    );
  }
}
