import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/providers/favourite_movies.dart';
import 'package:nest/features/home/widgets/movie_card.dart';
import 'package:nest/features/home/widgets/overview_dialog.dart';
import 'package:nest/features/home/widgets/rating_stars.dart';

class MovieDetails extends ConsumerWidget {
  const MovieDetails({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMoviesNotifier = ref.read(favouriteMoviesProvider.notifier);

    // Call this method during the build to ensure the state is up-to-date
    favouriteMoviesNotifier.checkIfMovieExists(movie);

    final movieExists =
        ref.watch(favouriteMoviesProvider.select((state) => state.movieExists));

    Widget cutLongOverview() {
      if (movie.overview!.characters.length > 250) {
        return RichText(
          text: TextSpan(
            text: movie.overview!.substring(0, 250),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: ' ... See More',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            OverviewDialog(overview: movie.overview!));
                  },
              ),
            ],
          ),
        );
      }
      return Text(
        movie.overview!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    Widget i = cutLongOverview();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(stretch: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 500.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: movie.uid!,
                child: MovieCard(
                  moviePoster: movie.posterPath!,
                  padding: 0,
                  raduis: 30,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 250.h,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.h, left: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                movie.title!,
                                style: TextStyle(
                                    fontSize: 32.h,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.h, left: 16.w),
                            child: Text(
                              DateTime.parse(movie.releaseDate!)
                                  .year
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                shape: BoxShape.circle),
                            height: 4.h,
                            width: 4.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 16.h, left: 16.w, right: 35.w),
                        child: i,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 8),
                    child: Text(
                      'Tracking & Rating',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Row(
                    children: [
                      RatingStars(
                        rating: movie.voteAverage!,
                      ),
                      SizedBox(
                        width: 26.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          favouriteMoviesNotifier.addFavouriteMovie(movie,context);
                        },
                        child: Icon(
                          CupertinoIcons.eye_fill,
                          color: movieExists
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          size: 40.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
