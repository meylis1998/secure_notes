import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/view/home_view.dart';
import '../../../local/local_notes.dart';
import '../../../main/main_shell.dart';
import '../../../splash/splash_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeTabNavKey = GlobalKey<NavigatorState>();
final _localTabNavKey = GlobalKey<NavigatorState>();

class AppRoutes {
  // Top-level routes
  static const initial = '/';
  // Bottom Navigation routes
  static const home = '/home';
  static const local = '/local';

  static final GoRoute splashRoute = GoRoute(
    path: initial,
    builder: (context, state) => const SplashView(),
  );

  static final GoRoute _home = GoRoute(
    path: home,
    builder: (context, state) => const HomeView(),
  );

  static final GoRoute _local = GoRoute(
    path: local,
    builder: (context, state) => const LocalNotes(),
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
          StatefulShellBranch(navigatorKey: _localTabNavKey, routes: [_local]),
        ],
      ),
    ],
  );
}
