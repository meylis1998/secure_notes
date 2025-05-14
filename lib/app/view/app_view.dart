import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_data_src/notes_data_src.dart';
import 'package:secure_notes/app/config/utils/secure_storage_helper.dart';
import '../../di/di.dart';
import '../../home/bloc/note_bloc.dart';
import '../config/config.dart';
import '../theme/app_theme.dart';
import '../theme/theme_cubit.dart';

class SecureNotesApp extends StatelessWidget {
  const SecureNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create:
              (context) => NotesRemoteDataSrc(
                dioClientHandler: injector<DioClientHandler>(),
              ),
        ),
        RepositoryProvider<SecureStorageHelper>(
          create: (context) => injector<SecureStorageHelper>(),
        ),
        RepositoryProvider<LocalNotesDataSrc>(
          create: (context) => injector<LocalNotesDataSrc>(),
        ),
      ],
      child: SecureNotesAppView(),
    );
  }
}

class SecureNotesAppView extends StatelessWidget {
  const SecureNotesAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => NoteBloc(
            localNotesDataSrc: context.read<LocalNotesDataSrc>(),
            remoteDataSrc: context.read<NotesRemoteDataSrc>(),
          ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScreenUtilInit(
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            builder: (context, child) {
              return BlocProvider<ThemeCubit>(
                create: (_) => ThemeCubit(),
                child: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, mode) {
                    return MaterialApp.router(
                      title: 'Secure notes',
                      theme: AppTheme().lightTheme,
                      darkTheme: AppTheme().darkTheme,
                      themeMode: mode,
                      debugShowCheckedModeBanner: false,
                      routeInformationProvider:
                          AppRoutes.router.routeInformationProvider,
                      routeInformationParser:
                          AppRoutes.router.routeInformationParser,
                      routerDelegate: AppRoutes.router.routerDelegate,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
