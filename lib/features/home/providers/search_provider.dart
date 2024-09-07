import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends StateNotifier<List<Movie>> {
  SearchProvider() : super([]);

  Future<void> searchMovieList(String query) async {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$tmbdApiKey&query=$query'; // Updated URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?; // Safely cast to List or null

        if (results != null) {
          state = results
              .where((item) => item is Map<String, dynamic>) // Ensure each item is a map
              .map((json) => Movie.fromJson(json as Map<String, dynamic>)) // Safely cast to Map
              .toList();
        } else {
          state = [];
        }
      } else {
        throw Exception('Error fetching search results');
      }
    } catch (e) {
      print('Error: $e');
      state = []; // Clear the state or handle the error as needed
    }
  }
}

final searchProvider = StateNotifierProvider<SearchProvider, List<Movie>>(
  (ref) => SearchProvider(),
);
