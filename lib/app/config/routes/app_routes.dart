import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/view/home_view.dart';
import '../../../splash/splash_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

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

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initial,
    routes: [splashRoute, _home],
  );
}
