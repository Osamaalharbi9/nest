import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nest/core/services.dart'; // Ensure apiKey is properly managed
import 'package:nest/features/home/models/movie.dart';

class MovieProvider extends StateNotifier<Map<String, List<Movie>>> {
  MovieProvider() : super({});

  // Fetch individual movie lists by endpoint
  Future<List<Movie>> fetchPopularMovies() async =>
      fetchMoviesByEndpoint('/popular');
  // Future<List<Movie>> fetchLatestMovies() async =>
  //     fetchMoviesByEndpoint('/latest');
  Future<List<Movie>> fetchUpcomingMovies() async =>
      fetchMoviesByEndpoint('/upcoming');
  Future<List<Movie>> fetchTopRatedMovies() async =>
      fetchMoviesByEndpoint('/top_rated');

  Future<List<Movie>> fetchMoviesByEndpoint(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie$endpoint?api_key=$tmbdApiKey'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['results'] == null) {
          print('Warning: $endpoint returned null for results.');
          return []; // Return an empty list if results are null
        }
        final List<dynamic> loadedData = data['results'];
        print('Successfully fetched movies from $endpoint');
        return loadedData.map((json) => Movie.fromJson(json)).toList();
      } else {
        print(
            'Error fetching $endpoint: ${response.statusCode} ${response.body}');
        throw Exception(
            'Failed to load movies from $endpoint with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught fetching movies from $endpoint: $e');
      throw Exception('Exception caught fetching movies from $endpoint: $e');
    }
  }

  // Combined function to fetch all movies and return the map
  Future<Map<String, List<Movie>>> fetchAllMovies() async {
    try {
      print('Starting to fetch all movies...');

      final results = await Future.wait([
        fetchPopularMovies(),
        //   fetchLatestMovies(),
        fetchUpcomingMovies(),
        fetchTopRatedMovies(),
      ]);

      print('Movies fetched successfully');

      // Ensure keys are consistent and simple (without leading slashes)
      final allMovies = {
        'popular': results[0],
        // 'latest': results[1],
        'upcoming': results[1],
        'top_rated': results[2],
      };

      state = allMovies; // Update the state for Riverpod
      return allMovies; // Also return the map
    } catch (e) {
      print(
          'Exception caught fetching all movies: $e'); // Print the detailed exception
      throw Exception(
          'Failed to fetch all movies: $e'); // Include the error message in the exception
    }
  }
}

final movieProvider =
    StateNotifierProvider<MovieProvider, Map<String, List<Movie>>>((ref) {
  return MovieProvider();
});
