import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar(this.content, this.color, BuildContext context)
      : super(
            content: content,
            behavior: SnackBarBehavior.floating,
            backgroundColor: color,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150.h,
                right: 16.w,
                left: 16.w));
  final Color color;
  final Widget content;
}
