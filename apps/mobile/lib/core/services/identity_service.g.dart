// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(identityService)
const identityServiceProvider = IdentityServiceProvider._();

final class IdentityServiceProvider
    extends
        $FunctionalProvider<IdentityService, IdentityService, IdentityService>
    with $Provider<IdentityService> {
  const IdentityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'identityServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$identityServiceHash();

  @$internal
  @override
  $ProviderElement<IdentityService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdentityService create(Ref ref) {
    return identityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdentityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdentityService>(value),
    );
  }
}

String _$identityServiceHash() => r'f857740f17436db54c116d6ffe259f7045a8ffc7';
