import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SecureStorageHelper {
  static const _keyName = 'hive_enc_key';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<List<int>> getOrCreateEncryptionKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null) {
      final bytes = base64Url.decode(existing);

      return bytes;
    }

    final newKey = Hive.generateSecureKey();
    final encoded = base64Url.encode(newKey);
    await _storage.write(key: _keyName, value: encoded);
    return newKey;
  }
}
