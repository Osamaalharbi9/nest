import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/pages/movie_details.dart';
import 'package:nest/features/home/widgets/movie_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MoviesRow extends StatelessWidget {
  const MoviesRow(
      {super.key,
      required this.rowTitle,
      required this.moviesList,
      required this.onTap});
  final String rowTitle;
  final List<Movie> moviesList;

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(children: [
            Text(
              rowTitle,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
            ).animate(effects: [
              FadeEffect(duration: Duration(milliseconds: 300)),BlurEffect(end: Offset(0, 0),duration: Duration(milliseconds: 300),begin: Offset(5, 5)),
              SlideEffect(
                  begin: Offset(0, 0.5),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate)
            ]),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 8.h,
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              ...moviesList.take(10).map((movie) => Hero(
                    tag: movie.uid!,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                        movie: movie,
                                      )));
                        },
                        child: MovieCard(
                          raduis: 0,
                          moviePoster: movie.posterPath!,
                          padding: 8,
                        )),
                  ))
            ]))
      ],
    );
  }
}
