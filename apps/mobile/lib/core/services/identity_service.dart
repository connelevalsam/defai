/*
* Created by Connel Asikong on 13/03/2026
*
*/

import 'package:bip39/bip39.dart' as bip39;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'identity_service.g.dart';

class IdentityService {
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  /*String derivePrivateKey(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);

    final child = root.derivePath("m/84'/1776'/0'/0/0");
    return HEX.encode(child.privateKey!);
  }*/

  bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }
}

@riverpod
IdentityService identityService(Ref ref) => IdentityService();
