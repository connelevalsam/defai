// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileData)
const profileDataProvider = ProfileDataProvider._();

final class ProfileDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileData>,
          ProfileData,
          FutureOr<ProfileData>
        >
    with $FutureModifier<ProfileData>, $FutureProvider<ProfileData> {
  const ProfileDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDataHash();

  @$internal
  @override
  $FutureProviderElement<ProfileData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileData> create(Ref ref) {
    return profileData(ref);
  }
}

String _$profileDataHash() => r'25305be6b3827210f2e90808a1c9ef3f4e08b95b';
