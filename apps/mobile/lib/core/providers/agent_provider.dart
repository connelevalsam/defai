/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/storage_keys.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

part 'agent_provider.g.dart';

enum AgentStatus {
  idle,
  thinking,
  reasoning,
  awaitingHandshake,
  executing,
  success,
  error,
}

class AgentState {
  final AgentStatus status;
  final String message;
  final List<String> logicSteps; // The "Reasoning" steps
  final String? txHash; // populated on success
  final String? strategyType; // carried through for execution
  final Map<String, dynamic> strategyParams;
  final String? errorMessage;

  AgentState({
    required this.status,
    this.message = "Sovereign Shield Active",
    this.logicSteps = const [],
    this.txHash,
    this.strategyType,
    this.strategyParams = const {},
    this.errorMessage,
  });

  AgentState copyWith({
    AgentStatus? status,
    String? message,
    List<String>? logicSteps,
    String? txHash,
    String? strategyType,
    Map<String, dynamic>? strategyParams,
    String? errorMessage,
  }) => AgentState(
    status: status ?? this.status,
    message: message ?? this.message,
    logicSteps: logicSteps ?? this.logicSteps,
    txHash: txHash ?? this.txHash,
    strategyType: strategyType ?? this.strategyType,
    strategyParams: strategyParams ?? this.strategyParams,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@riverpod
class Agent extends _$Agent {
  final _localAuth = LocalAuthentication();

  @override
  AgentState build() => AgentState(status: AgentStatus.idle);

  Future<void> processCommand(String command) async {
    final api = ref.read(apiServiceProvider);

    // 1. Thinking phase
    state = AgentState(
      status: AgentStatus.thinking,
      message: "Parsing intent...",
    );

    // 2. Reasoning phase (Breaking down the logic)
    try {
      final reasoning = await api.getReasoning(command);

      state = AgentState(
        status: AgentStatus.reasoning,
        message: 'Formulating execution plan...',
        logicSteps: reasoning.steps,
        strategyType: reasoning.strategyType,
        strategyParams: reasoning.params,
      );

      // Let reasoning board animate before proceeding
      await Future.delayed(
        const Duration(milliseconds: 600) * reasoning.steps.length,
      );
    } catch (e) {
      // Server unreachable — fall back to local reasoning
      final fallback = _localReasoning(command);
      state = AgentState(
        status: AgentStatus.reasoning,
        message: 'Formulating execution plan...',
        logicSteps: fallback.steps,
        strategyType: fallback.strategyType,
        strategyParams: fallback.params,
      );
      await Future.delayed(const Duration(seconds: 2));
    }

    // Phase 3 — Sovereign Handshake gate
    state = state.copyWith(
      status: AgentStatus.awaitingHandshake,
      message: 'Awaiting Sovereign Handshake...',
    );

    final authorized = await _sovereignHandshake();
    if (!authorized) {
      state = AgentState(
        status: AgentStatus.idle,
        message: 'Execution cancelled — handshake denied.',
      );
      return;
    }

    // Phase 4 — execute (handshake passed)
    await _executeOnchain();
  }

  // The biometric gate — only this method calls sign_transaction in Rust
  Future<bool> _sovereignHandshake() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authorize Sentinel to execute strategy',
        biometricOnly: false,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> executeStrategy() async {
    state = state.copyWith(
      status: AgentStatus.executing,
      message: "Sentinel executing — broadcasting to Liquid...",
    );

    try {
      final api = ref.read(apiServiceProvider);
      final address = await StorageService().getKey(StorageKeys.vaultAddress);

      if (address == null) {
        throw Exception('Vault address not found. Re-initialise wallet.');
      }

      final result = await api.executeStrategy(
        address: address,
        strategyType: state.strategyType ?? 'auto_save',
        params: state.strategyParams,
      );

      if (result.executed && result.results.isNotEmpty) {
        final txHash = result.results.first['txHash'] as String?;
        final description = result.results.first['description'] as String?;

        state = state.copyWith(
          status: AgentStatus.success,
          message: description ?? 'Strategy executed successfully.',
          txHash: txHash,
        );
      } else {
        // Strategy conditions not met — not an error
        state = state.copyWith(
          status: AgentStatus.success,
          message:
              result.reason ?? 'Strategy conditions not met — no action taken.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.error,
        message: 'Execution failed.',
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _executeOnchain() async {
    state = state.copyWith(
      status: AgentStatus.executing,
      message: 'Sentinel executing — broadcasting to Liquid...',
    );

    try {
      final api = ref.read(apiServiceProvider);
      final address = await StorageService().getKey(StorageKeys.vaultAddress);

      if (address == null) {
        throw Exception('Vault address not found. Re-initialise wallet.');
      }

      // Build params — inject savingsAddress for auto_save
      final params = Map<String, dynamic>.from(state.strategyParams);
      if (state.strategyType == 'auto_save' &&
          !params.containsKey('savingsAddress')) {
        params['savingsAddress'] = address; // self-custody demo loop
      }

      final result = await api.executeStrategy(
        address: address,
        strategyType: state.strategyType ?? 'auto_save',
        params: params,
      );

      if (result.executed && result.results.isNotEmpty) {
        final txHash = result.results.first['txHash'] as String?;
        final description = result.results.first['description'] as String?;
        state = state.copyWith(
          status: AgentStatus.success,
          message: description ?? 'Strategy executed successfully.',
          txHash: txHash,
        );
      } else {
        state = state.copyWith(
          status: AgentStatus.success,
          message:
              result.reason ?? 'Strategy conditions not met — no action taken.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.error,
        message: 'Execution failed.',
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = AgentState(status: AgentStatus.idle);
  }

  // ── Local fallback reasoning (when server unreachable) ─────────────────────

  ({List<String> steps, String strategyType, Map<String, dynamic> params})
  _localReasoning(String command) {
    final lower = command.toLowerCase();

    if (lower.contains('save')) {
      return (
        steps: [
          'Check USD₮ balance in WDK Vault',
          'Calculate 10% savings threshold',
          'Verify no pending transactions',
          'Prepare self-custodial USD₮ transfer',
        ],
        strategyType: 'auto_save',
        params: {'percentage': 10},
      );
    }

    if (lower.contains('gold') || lower.contains('xau')) {
      return (
        steps: [
          'Fetch XAU₮/USD₮ rate from Tether Oracle',
          'Evaluate balance vs threshold',
          'Check Liquid network fee estimate',
          'Prepare XAU₮ conversion transaction',
        ],
        strategyType: 'gold_threshold',
        params: {'threshold': 1000},
      );
    }

    return (
      steps: [
        'Analyse command intent',
        'Identify relevant assets',
        'Build execution strategy',
        'Prepare transaction payload',
      ],
      strategyType: 'unknown',
      params: <String, dynamic>{},
    );
  }
}
