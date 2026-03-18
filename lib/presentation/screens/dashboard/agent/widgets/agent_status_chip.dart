/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/providers/agent_provider.dart';
import '../../../../../utils/defai_themes.dart';

class AgentStatusChip extends StatelessWidget {
  const AgentStatusChip({super.key, required this.status});

  final AgentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      AgentStatus.idle => ('IDLE', NeonColors.textGrey),
      AgentStatus.thinking => ('THINKING', NeonColors.neonPurple),
      AgentStatus.reasoning => ('REASONING', NeonColors.neonCyan),
      AgentStatus.awaitingHandshake => ('AWAITING AUTH', NeonColors.neonPink),
      AgentStatus.executing => ('EXECUTING', NeonColors.neonCyan),
      AgentStatus.success => ('CONFIRMED', Colors.greenAccent),
      AgentStatus.error => ('ERROR', NeonColors.neonPink),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1, end: 0.5, duration: 900.ms),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
