// lib/core/app_initializer.dart

import 'dart:async';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../di/di.dart';
import 'secure_storage_helper.dart';

class AppInitializer {
  /// Initializes Hive, HydratedBloc and any other services.
  static Future<void> init() async {
    // 1. Hive
    await Hive.initFlutter();

    final key = await SecureStorageHelper.getOrCreateEncryptionKey();

    Hive
      ..registerAdapter(NoteAdapter())
      ..registerAdapter(NoteFileAdapter())
      ..registerAdapter(OwnerAdapter());

    await Hive.openBox<Note>(
      'secure_notes',
      encryptionCipher: HiveAesCipher(key),
    );

    // 2. Hydrated Bloc
    final tempDir = await getTemporaryDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(tempDir.path),
    );

    // 3. Any other DI / services
    await initServices();
  }
}
