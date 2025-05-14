import 'package:get_it/get_it.dart';
import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:notes_data_src/encryption_service.dart';
import 'package:notes_data_src/notes_data_src.dart';
import 'package:secure_notes/app/config/utils/secure_storage_helper.dart';

import '../app/config/utils/local_notes.dart';

/// Global service locator
final injector = GetIt.instance;

Future<void> initServices() async {
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());
  final secureStorage = SecureStorageHelper();

  injector.registerSingleton<SecureStorageHelper>(secureStorage);

  final encryptionService = EncryptionService();
  await encryptionService.initialize();

  injector.registerSingleton<EncryptionService>(encryptionService);

  injector.registerLazySingleton<NotesRemoteDataSrc>(
    () => NotesRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
  );

  injector.registerLazySingleton<LocalNotesDataSrc>(
    () => LocalNotesHive(), // <-- now using Hive
  );
}
