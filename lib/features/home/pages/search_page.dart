import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/providers/search_provider.dart';
import 'package:nest/features/home/pages/movie_details.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<Movie> _searchResults = []; // To store search results
  bool _isLoading = false; // To indicate when loading is happening

  void _searchMovies(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final searchNotifier = ref.read(searchProvider.notifier);
      try {
        final results = await searchNotifier.getSearchedMovies(query);
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        // Handle the error by showing a message or a snack bar
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Search'),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                      _searchMovies(value); // Call the search function
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Looking for a movie?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                          ? const Center(child: Text('No movies found'))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final movie = _searchResults[index];
                                  return ListTile(
                                    title: Hero(
                                      tag: movie.uid!,
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieDetails(
                                                            movie: movie)));
                                          },
                                          child: Material(
                                            child: ListTile(
                                              leading: Image.network(
                                                  httpPoster +
                                                      movie.posterPath!),
                                              title: Text(movie.title!),
                                            ),
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
