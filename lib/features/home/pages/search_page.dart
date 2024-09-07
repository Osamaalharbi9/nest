import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/providers/search_provider.dart';
import 'package:nest/features/home/pages/movie_details.dart';
import 'package:nest/features/home/widgets/movie_card.dart';
import 'package:nest/features/home/widgets/movie_tile.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  void _performSearch() {
    final searchNotifier = ref.read(searchProvider.notifier);
    searchNotifier.searchMovieList(_query);
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchProvider);

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
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Looking for a movie?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _performSearch,
                    child: const Text('Search'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: searchResults.isEmpty
                        ? const Center(
                            child: Text('No results'),
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              if (searchResults[index].title != null &&
                                  searchResults[index].overview != null &&
                                  searchResults[index].posterPath != null &&
                                  searchResults[index].voteAverage != null &&
                                  searchResults[index].releaseDate != null &&
                                  searchResults[index].uid != null)
                                return ListTile(
                                  title: Hero(
                                    tag: searchResults[index].uid!,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetails(
                                                          movie: searchResults[
                                                              index])));
                                        },
                                        child: Material(
                                          child: ListTile(
                                            leading: Image.network(httpPoster +
                                                searchResults[index].posterPath!),
                                            title:
                                                Text(searchResults[index].title!),
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
