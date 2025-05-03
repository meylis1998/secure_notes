import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../app/theme/app_theme.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  void _onTabTapped(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
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
            icon: Icon(LineAwesomeIcons.bookmark, size: 25.sp),
            activeIcon: Icon(
              Icons.bookmark,
              color: AppTheme.mainColor,
              size: 25.sp,
            ),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
