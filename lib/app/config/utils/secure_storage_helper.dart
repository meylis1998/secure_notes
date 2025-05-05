import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SecureStorageHelper {
  static const _keyName = 'hive_enc_key';
  // give _storage the correct type
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<List<int>> getOrCreateEncryptionKey() async {
    // now `read` and `write` are defined
    final existing = await _storage.read(key: _keyName);
    if (existing != null) return base64Url.decode(existing);
    final newKey = Hive.generateSecureKey();
    await _storage.write(key: _keyName, value: base64Url.encode(newKey));
    return newKey;
  }
}
