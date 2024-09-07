import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/profile/pages/profile_page.dart';
import 'package:nest/features/home/pages/home_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _controller = PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: Colors.black.withOpacity(0.4),
      navBarStyle: NavBarStyle.style9,
      margin: const EdgeInsets.all(20),
      decoration: NavBarDecoration(borderRadius: BorderRadius.circular(12.r)),
      controller: _controller,
      context,
      items: [
        PersistentBottomNavBarItem(
          activeColorSecondary: Colors.yellow,
          activeColorPrimary: Theme.of(context).colorScheme.onPrimary,
          icon: const Icon(Icons.movie),
          title: 'Movies',
        ),
        PersistentBottomNavBarItem(
            activeColorSecondary: Colors.yellow,
            activeColorPrimary: Theme.of(context).colorScheme.onPrimary,
            icon: const Icon(Icons.person),
            title: 'Profile')
      ],
      screens: const [Homepage(), ProfilePage()],
    );
  }
}
