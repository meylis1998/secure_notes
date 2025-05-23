import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static Color red = Colors.red.shade600;
  static const Color transparent = Colors.transparent;
  static const Color backgroundColor = Color(0xFF121212);
  static const Color unselectedColor = Colors.grey;
  static const Color greenColor = Color.fromRGBO(31, 210, 103, 1);
  static const Color green = Colors.green;
  static const Color blue = Color.fromRGBO(5, 99, 224, 1);
  static const Color scaffoldColorLight = Color.fromRGBO(242, 245, 255, 1);
  static const Color mainColor = Color.fromRGBO(180, 155, 135, 1);
  static const Color seeHistoryColor = Color.fromRGBO(5, 99, 224, 1);
  static const Color productBackgroundColor = Color.fromRGBO(239, 239, 239, 1);
  static const String fontFamily = 'Montserrat';

  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      primary: mainColor,
      seedColor: white,
      surface: const Color(0xFF121212),
    ),
    highlightColor: AppTheme.grey.withAlpha((0.2 * 255).toInt()),
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryTextTheme: TextTheme(bodyMedium: GoogleFonts.raleway()),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppTheme.white),
      color: backgroundColor,
      surfaceTintColor: AppTheme.white,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    iconTheme: IconThemeData(color: AppTheme.black),
    textTheme: TextTheme(bodyMedium: GoogleFonts.raleway()),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      labelStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      labelColor: AppTheme.black,
      unselectedLabelStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppTheme.white,
      enableFeedback: true,
    ),
    searchViewTheme: SearchViewThemeData(backgroundColor: AppTheme.white),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll<Color>(AppTheme.seeHistoryColor),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: AppTheme.grey.withAlpha((0.2 * 255).toInt()),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      elevation: 0,
      enableFeedback: true,
      selectedItemColor: AppTheme.mainColor,
      selectedIconTheme: const IconThemeData(size: 20),
      unselectedIconTheme: const IconThemeData(size: 20),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.raleway(
        color: AppTheme.mainColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.raleway(
        fontSize: 12,
        color: AppTheme.black,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      primary: AppTheme.mainColor,
      seedColor: AppTheme.black,
      surface: AppTheme.black,
      brightness: Brightness.dark,
    ),
    highlightColor: AppTheme.grey.withAlpha((0.2 * 255).toInt()),
    useMaterial3: true,
    fontFamily: AppTheme.fontFamily,
    primaryTextTheme: TextTheme(
      bodyMedium: GoogleFonts.raleway(color: AppTheme.white),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(size: 30.sp, color: AppTheme.white),
      color: AppTheme.black,
      surfaceTintColor: AppTheme.black,
    ),
    iconTheme: IconThemeData(color: AppTheme.white),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.raleway(color: AppTheme.white),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      labelStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      labelColor: AppTheme.white,
      unselectedLabelStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      unselectedLabelColor: AppTheme.grey,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.grey.shade800,
      iconColor: AppTheme.white,
      textColor: AppTheme.white,
    ),
    searchViewTheme: SearchViewThemeData(backgroundColor: Colors.grey.shade800),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade700),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: AppTheme.grey.withAlpha((0.2 * 255).toInt()),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppTheme.black,
      elevation: 0,
      enableFeedback: true,
      selectedItemColor: AppTheme.mainColor,
      selectedIconTheme: IconThemeData(size: 20, color: AppTheme.mainColor),
      unselectedIconTheme: IconThemeData(size: 20, color: AppTheme.grey),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.raleway(
        color: AppTheme.mainColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.raleway(
        fontSize: 12,
        color: AppTheme.grey,
      ),
    ),
    scaffoldBackgroundColor: AppTheme.black,
  );
}
