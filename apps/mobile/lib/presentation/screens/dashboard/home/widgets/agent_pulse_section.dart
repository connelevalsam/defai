/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/providers/agent_provider.dart';
import '../../../../../utils/defai_themes.dart';

class AgentPulseSection extends StatelessWidget {
  final AgentState agentState;

  const AgentPulseSection({super.key, required this.agentState});

  @override
  Widget build(BuildContext context) {
    final isActive = agentState.status != AgentStatus.idle;
    final color = switch (agentState.status) {
      AgentStatus.awaitingHandshake => NeonColors.neonPink,
      AgentStatus.success => Colors.greenAccent,
      AgentStatus.error => NeonColors.neonPink,
      _ => NeonColors.neonCyan,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Orb
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 0.85,
                      end: 1.0,
                      duration: 1800.ms,
                      curve: Curves.easeInOut,
                    )
                    .fadeIn(begin: 0.3),

                // Mid ring
                Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 0.9,
                      end: 1.05,
                      duration: 1400.ms,
                      curve: Curves.easeInOut,
                    ),

                // Core
                Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: isActive ? 0.12 : 0.05),
                        border: Border.all(
                          color: color.withValues(alpha: 0.7),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(
                              alpha: isActive ? 0.35 : 0.15,
                            ),
                            blurRadius: isActive ? 24 : 12,
                          ),
                        ],
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedAiBrain01,
                        color: color,
                        size: 30,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(
                      begin: 1.0,
                      end: isActive ? 1.08 : 1.02,
                      duration: 1000.ms,
                    ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Status label
          Text(
            'SENTINEL · ${agentState.status.name.toUpperCase()}',
            style: TextStyle(
              color: color,
              fontSize: 11,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
            ),
          ).animate(key: ValueKey(agentState.status)).fadeIn(duration: 400.ms),

          const SizedBox(height: 6),

          Text(
            agentState.message,
            style: const TextStyle(
              color: NeonColors.textGrey,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ).animate(key: ValueKey(agentState.message)).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
