import 'package:get_it/get_it.dart';
import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:notes_data_src/notes_data_src.dart';
import 'package:notes_repo/notes_repo.dart';

/// Global service locator
final injector = GetIt.instance;
Future<void> initServices() async {
  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

  // ─── Data Sources ─────────────────────────────────────────────────
  injector.registerLazySingleton<NotesRemoteDataSrc>(
    () => NotesRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
  );

  // ─── Repositories ─────────────────────────────────────────────────
  injector.registerLazySingleton<NotesRepo>(
    () => NotesRepo(dataSrc: injector<NotesRemoteDataSrc>()),
  );
}
