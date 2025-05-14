import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_notes/home/view/add_note_view.dart';
import 'package:secure_notes/local_auth/auth_gate.dart';

import '../../../home/view/home_view.dart';
import '../../../splash/splash_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const initial = '/';
  static const home = '/home';
  static const addNote = '/add_note';

  static final GoRoute splashRoute = GoRoute(
    path: initial,
    builder: (context, state) => const SplashView(),
  );

  static final GoRoute _home = GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => AuthGate(child: const HomeView()),
  );

  static final GoRoute _add_note = GoRoute(
    path: addNote,
    builder: (context, state) => const AddNoteView(),
  );

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initial,
    routes: [splashRoute, _home, _add_note],
  );
}
