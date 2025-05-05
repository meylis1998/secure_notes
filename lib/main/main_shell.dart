import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../app/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  void _onTabTapped(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTabTapped(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.home_solid, size: 25.sp),
            activeIcon: Icon(
              Icons.home,
              color: AppTheme.mainColor,
              size: 25.sp,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined, size: 25.sp),
            activeIcon: Icon(
              Icons.note,
              color: AppTheme.mainColor,
              size: 25.sp,
            ),
            label: 'Local Notes',
          ),
        ],
      ),
    );
  }
}
