// lib/theme/cubit/theme_cubit.dart

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode mode) {
    return {'theme': mode == ThemeMode.dark ? 'dark' : 'light'};
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final str = json['theme'] as String?;
    if (str == 'dark') return ThemeMode.dark;
    return ThemeMode.light;
  }
}
