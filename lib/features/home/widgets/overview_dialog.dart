import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/home/pages/home_page.dart';

class OverviewDialog extends StatelessWidget {
  const OverviewDialog({super.key, required this.overview});

  final String overview;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Text(overview,textAlign: TextAlign.center,),
      ),
    );
  }
}