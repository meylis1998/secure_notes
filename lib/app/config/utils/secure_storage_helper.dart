import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SecureStorageHelper {
  static const _keyName = 'hive_enc_key';
  // give _storage the correct type
  static final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<List<int>> getOrCreateEncryptionKey() async {
    final existing = await _storage.read(key: _keyName);
    debugPrint('🔑 [SecureStorageHelper] existing key: $existing');
    if (existing != null) {
      final bytes = base64Url.decode(existing);
      debugPrint(
        '🔑 [SecureStorageHelper] decoded key length: ${bytes.length}',
      );
      return bytes;
    }

    final newKey = Hive.generateSecureKey();
    final encoded = base64Url.encode(newKey);
    await _storage.write(key: _keyName, value: encoded);
    debugPrint('🔑 [SecureStorageHelper] wrote new key: $encoded');
    return newKey;
  }
}
