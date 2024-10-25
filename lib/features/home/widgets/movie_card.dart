import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/core/services.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(
      {super.key,
      required this.moviePoster,
      required this.padding,
      required this.raduis});

  final String moviePoster;
  final double padding;
  final double raduis;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: padding.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(raduis.r),
        child: GestureDetector(
          child: Image.network(
            httpPoster + moviePoster,
            width: 120.sp,
            height: 180.sp,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container(
                  width: 120.sp,
                  height: 180.sp,
                  color: Theme.of(context).colorScheme.surface,
                );
              }
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                width: 120.sp,
                height: 180.sp,
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey.shade400,
                  size: 50.sp,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
