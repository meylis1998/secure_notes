// lib/core/app_initializer.dart

import 'dart:async';
import 'package:models/models.dart';
import 'package:notes_data_src/encryption_service.dart';
import 'package:notes_data_src/notes_data_src.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../di/di.dart';
import 'secure_storage_helper.dart';

class AppInitializer {
  static Future<void> init() async {
    await Hive.initFlutter();

    final key = await SecureStorageHelper.getOrCreateEncryptionKey();

    Hive.registerAdapter(NoteAdapter());

    await Hive.openBox<Note>(
      'secure_notes',
      encryptionCipher: HiveAesCipher(key),
    );

    final encryptionService = EncryptionService();
    await encryptionService.initialize();

    final tempDir = await getTemporaryDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(tempDir.path),
    );

    await initServices();
    await injector<LocalNotesDataSrc>().getNotes();
  }
}
