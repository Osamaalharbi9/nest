import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/pages/movie_details.dart';
import 'package:nest/features/home/providers/search_provider.dart';

class SheetSearch extends ConsumerStatefulWidget {
  const SheetSearch({super.key, required this.movieTitle});
  final String movieTitle;

  @override
  _SheetSearchState createState() => _SheetSearchState();
}

class _SheetSearchState extends ConsumerState<SheetSearch> {
  late TextEditingController _controller;
  String query = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.movieTitle);
    query = widget.movieTitle; // Set initial query to the provided movie title
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchNotifier = ref.read(searchProvider.notifier);

    return SizedBox(
      width: double.infinity,
      height: 300.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value; // Update the query as the user types
                });
              },
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            FutureBuilder(
              future: searchNotifier
                  .getSearchedMovies(query), // Use the updated query
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount:
                          snapshot.data!.take(1).length, // Show all results
                      itemBuilder: (context, index) {
                        return Hero(
                          tag: snapshot.data![index].uid!,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                    movie: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Image.network(httpPoster +
                                  snapshot.data![index].posterPath!),
                              title: Text(snapshot.data![index].title!),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
