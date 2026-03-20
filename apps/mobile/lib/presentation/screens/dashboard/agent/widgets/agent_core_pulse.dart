/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

import '../../../../../core/providers/agent_provider.dart';
import '../../../../../utils/defai_themes.dart';

class AgentCorePulse extends StatelessWidget {
  const AgentCorePulse({super.key, required this.status});

  final AgentStatus status;

  @override
  Widget build(BuildContext context) {
    final isActive = status != AgentStatus.idle;
    final color = switch (status) {
      AgentStatus.awaitingHandshake => NeonColors.neonPink,
      AgentStatus.success => Colors.greenAccent,
      AgentStatus.error => NeonColors.neonPink,
      _ => NeonColors.neonCyan,
    };

    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                )
                .animate(onPlay: (c) => isActive ? c.repeat() : c.stop())
                .scaleXY(
                  begin: 0.8,
                  end: 1.0,
                  duration: 1200.ms,
                  curve: Curves.easeInOut,
                )
                .fadeIn(begin: 0.2),

            // Middle ring
            Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                )
                .animate(onPlay: (c) => isActive ? c.repeat() : c.stop())
                .scaleXY(
                  begin: 0.9,
                  end: 1.05,
                  duration: 900.ms,
                  curve: Curves.easeInOut,
                ),

            // Core
            Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: isActive ? 0.15 : 0.05),
                    border: Border.all(
                      color: color.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 20,
                            ),
                          ]
                        : null,
                  ),
                  child: HugeIcon(
                    icon: switch (status) {
                      AgentStatus.awaitingHandshake =>
                        HugeIconsStrokeRounded.fingerPrint,
                      AgentStatus.success =>
                        HugeIcons.strokeRoundedCheckmarkCircle01,
                      AgentStatus.executing =>
                        HugeIcons.strokeRoundedLinkCircle02,
                      _ => HugeIcons.strokeRoundedAiBrain01,
                    },
                    color: color,
                    size: 26,
                  ),
                )
                .animate(
                  onPlay: (c) => isActive ? c.repeat(reverse: true) : c.stop(),
                )
                .scaleXY(
                  begin: 1.0,
                  end: isActive ? 1.1 : 1.0,
                  duration: 800.ms,
                ),
          ],
        ),
      ),
    );
  }
}

//  HugeIcon(icon: HugeIconsStrokeRounded.fingerPrint,),
