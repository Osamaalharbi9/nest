import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nest/features/auth/widgets/auth_sheet.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}



class _AuthViewState extends ConsumerState<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 1.1, 50.h),
                      backgroundColor: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (e) => const AuthSheet());
                  },
                  child: Text('Join Nest!',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSecondary))),
            ),
          )
        ],
      ),
    );
  }
}
