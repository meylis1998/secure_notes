// lib/core/app_initializer.dart

import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../di/di.dart';
import 'secure_storage_helper.dart';

class AppInitializer {
  static Future<void> init() async {
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

    final tempDir = await getTemporaryDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(tempDir.path),
    );
    await dotenv.load(fileName: '.env');
    dotenv.env['github_token'];
    await initServices();
  }
}
