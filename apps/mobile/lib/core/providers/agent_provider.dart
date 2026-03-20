/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  final String? errorMessage;

  AgentState({
    required this.status,
    this.message = "Sovereign Shield Active",
    this.logicSteps = const [],
    this.errorMessage,
  });

  AgentState copyWith({
    AgentStatus? status,
    String? message,
    List<String>? logicSteps,
    String? errorMessage,
  }) => AgentState(
    status: status ?? this.status,
    message: message ?? this.message,
    logicSteps: logicSteps ?? this.logicSteps,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@riverpod
class Agent extends _$Agent {
  final _localAuth = LocalAuthentication();

  @override
  AgentState build() => AgentState(status: AgentStatus.idle);

  Future<void> processCommand(String command) async {
    // 1. Thinking phase
    state = AgentState(
      status: AgentStatus.thinking,
      message: "Parsing intent...",
    );
    await Future.delayed(const Duration(seconds: 1));

    // 2. Reasoning phase (Breaking down the logic)
    state = AgentState(
      status: AgentStatus.reasoning,
      message: "Formulating execution plan...",
      logicSteps: _buildReasoningSteps(command),
    );
    await Future.delayed(const Duration(seconds: 1));

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
    await executeStrategy();
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
    state = AgentState(
      status: AgentStatus.executing,
      message: "Sentinel executing — broadcasting to Liquid...",
    );

    // TODO: call Rust bridge here
    // final result = await RustBridge.executeStrategy(...)
    await Future.delayed(const Duration(seconds: 2));

    state = AgentState(
      status: AgentStatus.success,
      message: 'Transaction confirmed — strategy live.',
    );
  }

  List<String> _buildReasoningSteps(String command) {
    // Rule-based for MVP — post-hackathon: LLM-powered
    final lower = command.toLowerCase();
    if (lower.contains('save') || lower.contains('usd')) {
      return [
        'Check USD₮ balance in WDK Vault',
        'Calculate 10% savings threshold',
        'Verify no pending transactions',
        'Prepare self-custodial transfer',
      ];
    }
    if (lower.contains('gold') || lower.contains('xau')) {
      return [
        'Fetch XAU₮/USD₮ rate from Tether Oracle',
        'Evaluate current balance vs threshold',
        'Check Liquid network fee estimate',
        'Prepare XAU₮ conversion transaction',
      ];
    }
    return [
      'Analyse command intent',
      'Identify relevant assets',
      'Build execution strategy',
      'Prepare transaction payload',
    ];
  }

  void reset() {
    state = AgentState(status: AgentStatus.idle);
  }
}
