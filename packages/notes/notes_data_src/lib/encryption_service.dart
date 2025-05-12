import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _keyName = 'notes_encryption_key';
  final FlutterSecureStorage _secureStorage;
  late Key _encryptionKey;
  late Encrypter _encrypter;
  late IV _iv;

  EncryptionService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> initialize() async {
    String? storedKey = await _secureStorage.read(key: _keyName);
    try {
      if (storedKey == null) {
        final key = Key.fromSecureRandom(32);
        await _secureStorage.write(
          key: _keyName,
          value: base64Encode(key.bytes),
        );
        _encryptionKey = key;
      } else {
        _encryptionKey = Key(base64Decode(storedKey));
      }

      _encrypter = Encrypter(AES(_encryptionKey));
      _iv = IV.fromLength(16);
    } catch (e) {
      print('Encryption error: $e');
    }
  }

  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}
