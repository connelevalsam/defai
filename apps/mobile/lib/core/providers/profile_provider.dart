/*
* Created by Connel Asikong on 22/03/2026
*
*/

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/storage_keys.dart';
import '../services/storage_service.dart';

part 'profile_provider.g.dart';

class ProfileData {
  final String vaultAddress;
  final bool biometricEnabled;

  const ProfileData({
    required this.vaultAddress,
    required this.biometricEnabled,
  });
}

@riverpod
Future<ProfileData> profileData(Ref ref) async {
  final storage = StorageService();
  final address = await storage.getKey(StorageKeys.vaultAddress);
  final biometric = await storage.getKey(StorageKeys.biometricEnabled);

  return ProfileData(
    vaultAddress: address ?? 'Not initialised',
    biometricEnabled: biometric == 'true',
  );
}
