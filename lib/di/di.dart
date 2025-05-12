import 'package:get_it/get_it.dart';
import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:notes_data_src/encryption_service.dart';
import 'package:notes_data_src/notes_data_src.dart';

/// Global service locator
final injector = GetIt.instance;
Future<void> initServices() async {
  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());
  injector.registerLazySingleton<EncryptionService>(() => EncryptionService());

  // ─── Data Sources ─────────────────────────────────────────────────
  injector.registerLazySingleton<NotesRemoteDataSrc>(
    () => NotesRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
  );

  injector.registerLazySingleton(
    () => LocalNotesDataSrc(encryptionService: injector<EncryptionService>()),
  );
}
