/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../utils/storage_keys.dart';
import '../services/storage_service.dart';

enum AuthState { initial, unauthenticated, registering, locked, authenticated }

class AuthNotifier extends Notifier<AuthState> {
  final _localAuth = LocalAuthentication();
  final _storage = StorageService();

  @override
  AuthState build() {
    _checkSecurityStatus();
    return AuthState.initial;
  }

  Future<void> _checkSecurityStatus() async {
    final key = await _storage.getMnemonic();
    if (key == null) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState.locked; // Key exists, but needs FaceID/PIN
    }
  }

  // "Login" via Biometrics
  Future<bool> unlockWithBiometrics() async {
    try {
      final bool canAuthenticate =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        // Handle devices with NO security at all
        state = AuthState.unauthenticated;
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Unlock your DeFAI Vault',
        biometricOnly: false,
      );

      if (didAuthenticate) {
        state = AuthState.authenticated;
      }

      return didAuthenticate;
    } on PlatformException catch (e) {
      // Handle specific errors like 'NotEnrolled' or 'LockedOut'
      print("Security Error: ${e.code}");
      return false;
    }
  }

  void beginRegistration() {
    state = AuthState.registering;
  }

  Future<void> completeRegistration() async {
    state = AuthState.authenticated;
  }

  Future<void> lock() async {
    state = AuthState.locked;
  }

  Future<void> wipeVault() async {
    await _storage.deleteVault();
    await _storage.saveKey(StorageKeys.onboardingComplete, 'false');
    state = AuthState.unauthenticated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
