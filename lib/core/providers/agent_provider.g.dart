// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Agent)
const agentProvider = AgentProvider._();

final class AgentProvider extends $NotifierProvider<Agent, AgentState> {
  const AgentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agentHash();

  @$internal
  @override
  Agent create() => Agent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgentState>(value),
    );
  }
}

String _$agentHash() => r'bd22836a6526bc3c8ef12d32519752a82712d474';

abstract class _$Agent extends $Notifier<AgentState> {
  AgentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AgentState, AgentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AgentState, AgentState>,
              AgentState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
