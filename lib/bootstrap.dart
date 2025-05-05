import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/config/utils/secure_storage_helper.dart';

import 'di/di.dart';

import 'package:path_provider/path_provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();

      final key = await SecureStorageHelper.getOrCreateEncryptionKey();

      Hive.registerAdapter(NoteAdapter());
      Hive.registerAdapter(NoteFileAdapter());
      Hive.registerAdapter(OwnerAdapter());

      await Hive.openBox<Note>(
        'secure_notes',
        encryptionCipher: HiveAesCipher(key),
      );

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          (await getTemporaryDirectory()).path,
        ),
      );

      await Future.wait([initServices()]);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(await builder());
    },
    (error, stackTrace) =>
        log(error.toString(), stackTrace: stackTrace, name: 'ERROR'),
  );
}
