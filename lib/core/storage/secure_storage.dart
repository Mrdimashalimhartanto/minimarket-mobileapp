import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kTempToken = 'temp_token';
  static const _kOtpRequired = 'otp_required';

  Future<void> setAccessToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);
  Future<String?> getAccessToken() => _storage.read(key: _kAccessToken);

  Future<void> setTempToken(String token) =>
      _storage.write(key: _kTempToken, value: token);
  Future<String?> getTempToken() => _storage.read(key: _kTempToken);

  Future<void> setOtpRequired(bool value) =>
      _storage.write(key: _kOtpRequired, value: value ? '1' : '0');
  Future<bool> getOtpRequired() async =>
      (await _storage.read(key: _kOtpRequired)) == '1';

  Future<void> clearAll() => _storage.deleteAll();
}
