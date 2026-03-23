/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:defai/utils/defai_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/providers/agent_provider.dart';
import 'widgets/agent_core_pulse.dart';
import 'widgets/agent_header.dart';
import 'widgets/command_input.dart';
import 'widgets/reasoning_board.dart';
import 'widgets/status_message.dart';
import 'widgets/suggested_commands.dart';

class AgentScreen extends ConsumerStatefulWidget {
  const AgentScreen({super.key});

  @override
  ConsumerState createState() => _AgentScreenState();
}

class _AgentScreenState extends ConsumerState<AgentScreen> {
  final _commandController = TextEditingController();
  final _focusNode = FocusNode();

  // Tracks how many reasoning steps have been "revealed" so far
  int _revealedSteps = 0;

  @override
  void dispose() {
    _commandController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // When the agent enters reasoning state, reveal steps one-by-one
  void _revealStepsProgressively(List<String> steps) async {
    setState(() => _revealedSteps = 0);
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _revealedSteps = i + 1);
    }
  }

  void _onSubmit(String command) {
    if (command.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    ref.read(agentProvider.notifier).processCommand(command.trim());
    _commandController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final agentState = ref.watch(agentProvider);

    // Trigger progressive reveal when reasoning starts
    ref.listen(agentProvider, (prev, next) {
      if (next.status == AgentStatus.reasoning &&
          prev?.status != AgentStatus.reasoning) {
        _revealStepsProgressively(next.logicSteps);
      }
      // Reset reveal count when agent goes idle
      if (next.status == AgentStatus.idle) {
        setState(() => _revealedSteps = 0);
      }
    });

    final isIdle =
        agentState.status == AgentStatus.idle ||
        agentState.status == AgentStatus.success ||
        agentState.status == AgentStatus.error;

    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          AgentHeader(status: agentState.status),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── Agent Core Pulse ──────────────────────────
                  AgentCorePulse(status: agentState.status),

                  const SizedBox(height: 28),

                  // ── Status Message ────────────────────────────
                  StatusMessage(message: agentState.message),

                  const SizedBox(height: 28),

                  // ── Reasoning Board ───────────────────────────
                  if (agentState.logicSteps.isNotEmpty)
                    ReasoningBoard(
                      steps: agentState.logicSteps,
                      revealedCount: _revealedSteps,
                      isExecuting: agentState.status == AgentStatus.executing,
                      isSuccess: agentState.status == AgentStatus.success,
                    ),

                  if (agentState.logicSteps.isNotEmpty)
                    const SizedBox(height: 28),

                  // ── Sovereign Handshake Banner ────────────────
                  if (agentState.status == AgentStatus.awaitingHandshake)
                    _sovereignHandshakeBanner(),

                  // ── Success Confirmation ──────────────────────
                  if (agentState.status == AgentStatus.success)
                    _successBanner(),

                  // ── Success Confirmation ──────────────────────
                  if (agentState.status == AgentStatus.error)
                    _errorBanner(
                      agentState.errorMessage ?? 'Something went wrong.',
                    ),

                  const SizedBox(height: 32),

                  // ── Command Input ─────────────────────────────
                  if (isIdle) ...[
                    CommandInput(
                      controller: _commandController,
                      focusNode: _focusNode,
                      onSubmit: _onSubmit,
                    ),
                    const SizedBox(height: 16),
                    SuggestedCommands(
                      onTap: (cmd) {
                        _commandController.text = cmd;
                        _onSubmit(cmd);
                      },
                    ),
                  ],

                  // ── Cancel / Reset ────────────────────────────
                  if (!isIdle) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            ref.read(agentProvider.notifier).reset(),
                        child: Text(
                          agentState.status == AgentStatus.success
                              ? 'DEPLOY ANOTHER STRATEGY'
                              : 'ABORT MISSION',
                          style: TextStyle(
                            color: agentState.status == AgentStatus.success
                                ? NeonColors.neonCyan
                                : NeonColors.neonPink,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Sovereign Handshake Banner
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _sovereignHandshakeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeonColors.neonPink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.neonPink.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          HugeIcon(
                icon: HugeIcons.strokeRoundedFingerPrint,
                color: NeonColors.neonPink,
                size: 36,
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.9, end: 1.1, duration: 800.ms),
          const SizedBox(height: 12),
          const Text(
            'SOVEREIGN HANDSHAKE REQUIRED',
            style: TextStyle(
              color: NeonColors.neonPink,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sentinel has prepared the strategy.\nYour biometric approval is required to execute.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95, end: 1.0);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Success Banner
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _successBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.greenAccent,
            size: 36,
          ),
          const SizedBox(height: 10),
          const Text(
            'STRATEGY LIVE ON LIQUID',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your Sentinel agent is now monitoring and executing autonomously.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.95, end: 1.0);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Error Banner
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _errorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeonColors.neonPink.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.neonPink.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.greenAccent, size: 36),
          const SizedBox(height: 10),
          const Text(
            'STRATEGY LIVE ON LIQUID',
            style: TextStyle(
              color: NeonColors.neonPink,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.95, end: 1.0);
  }
}
