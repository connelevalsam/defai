// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walletBalance)
const walletBalanceProvider = WalletBalanceProvider._();

final class WalletBalanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<BalanceResult>,
          BalanceResult,
          FutureOr<BalanceResult>
        >
    with $FutureModifier<BalanceResult>, $FutureProvider<BalanceResult> {
  const WalletBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletBalanceHash();

  @$internal
  @override
  $FutureProviderElement<BalanceResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BalanceResult> create(Ref ref) {
    return walletBalance(ref);
  }
}

String _$walletBalanceHash() => r'a01250408c963ca9c001debf8fdbe50c803aef20';
