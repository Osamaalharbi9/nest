import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/pages/movie_details.dart';
import 'package:nest/features/home/widgets/movie_card.dart';

class MoviesCategoryList extends StatelessWidget {
  const MoviesCategoryList({super.key, required this.fullCategoryList});
  final List<Movie> fullCategoryList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 80.h, top: 60.h),
              itemCount: fullCategoryList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.w,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: (context, index) {
                return Hero(
                  tag: fullCategoryList[index].uid!,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                  movie: fullCategoryList[index])));
                    },
                    child: MovieCard(
                      raduis: 0,
                      moviePoster:
                          httpPoster + fullCategoryList[index].posterPath!,
                      padding: 0,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80.h,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
