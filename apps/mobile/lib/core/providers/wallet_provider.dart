/*
* Created by Connel Asikong on 20/03/2026
*
*/

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/storage_keys.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

part 'wallet_provider.g.dart';

@riverpod
Future<BalanceResult> walletBalance(Ref ref) async {
  final address = await StorageService().getKey(StorageKeys.vaultAddress);
  if (address == null) {
    return BalanceResult(
      address: '',
      usdt: '0.00',
      xaut: '0.00',
      btc: '0.00000000',
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }
  return ref.read(apiServiceProvider).getBalance(address);
}
