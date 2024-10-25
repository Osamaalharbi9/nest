import 'package:flutter/cupertino.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/widgets/movie_card.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    required this.movie
  });
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Row(children: [Image.asset(httpPoster+movie.posterPath!)],);
  }
}
