/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/storage_keys.dart';

part 'storage_service.g.dart';

class StorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Mnemonic — this is the master secret, never the derived key
  Future<void> saveMnemonic(String mnemonic) async {
    await _storage.write(key: StorageKeys.vaultMnemonic, value: mnemonic);
  }

  Future<String?> getMnemonic() async {
    return await _storage.read(key: StorageKeys.vaultMnemonic);
  }

  Future<void> deleteVault() async {
    await _storage.delete(key: StorageKeys.vaultMnemonic);
    await _storage.delete(key: StorageKeys.vaultAddress);
  }

  // Generic KV for non-sensitive flags
  Future<void> saveKey(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getKey(String key) async {
    return await _storage.read(key: key);
  }
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final val = await StorageService().getKey(StorageKeys.onboardingComplete);
    if (ref.mounted) state = val == 'true';
  }

  Future<void> complete() async {
    await StorageService().saveKey(StorageKeys.onboardingComplete, 'true');
    if (ref.mounted) state = true;
  }
}
