import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest/bottom_navigator.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    // Calculate the number of stars based on the rating/2
    int numberOfStars = (rating / 2).round();

    // Create a list of star widgets
    List<Widget> stars = List.generate(5, (index) {
      if (index < numberOfStars) {
        // Filled star
        return SvgPicture.asset(width: 46.sp,
          'assets/images/Star 12.svg',
          color: Theme.of(context).colorScheme.primary,
        );
      } else {
        // Unfilled star
        return SvgPicture.asset(
          'assets/images/Star 12.svg',
        );
      }
    });

    return Row(
      children: stars,
    );
  }
}
