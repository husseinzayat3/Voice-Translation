import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<String> getApiKey() async {
    return await _storage.read(key: 'apiKey') ?? '';
  }

  static Future<void> setApiKey(String apiKey) async {
    await _storage.write(key: 'apiKey', value: apiKey);
  }
}