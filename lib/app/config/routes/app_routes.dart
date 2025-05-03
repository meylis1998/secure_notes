import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../bookmarks/bookmarks.dart';
import '../../../home/view/home_view.dart';
import '../../../main/main_shell.dart';
import '../../../splash/splash_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeTabNavKey = GlobalKey<NavigatorState>();
final _bookmarksTabNavKey = GlobalKey<NavigatorState>();

class AppRoutes {
  // Top-level routes
  static const initial = '/';
  // Bottom Navigation routes
  static const home = '/home';
  static const bookmarks = '/bookmarks';

  static final GoRoute splashRoute = GoRoute(
    path: initial,
    builder: (context, state) => const SplashView(),
  );

  static final GoRoute _home = GoRoute(
    path: home,
    builder: (context, state) => const HomeView(),
  );

  static final GoRoute _bookmarks = GoRoute(
    path: bookmarks,
    builder: (context, state) => const BookmarksView(),
  );

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initial,
    routes: [
      splashRoute,
      // Top-level routes.
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(navigatorKey: _homeTabNavKey, routes: [_home]),
          StatefulShellBranch(
            navigatorKey: _bookmarksTabNavKey,
            routes: [_bookmarks],
          ),
        ],
      ),
    ],
  );
}
