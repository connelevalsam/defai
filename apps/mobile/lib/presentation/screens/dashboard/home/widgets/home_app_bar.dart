/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:defai/core/providers/agent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../utils/defai_themes.dart';

class HomeAppBar extends StatelessWidget {
  final AgentState agentState;

  const HomeAppBar({super.key, required this.agentState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DeFAI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'SOVEREIGN FINANCE',
                style: TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 9,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Network badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: NeonColors.neonCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NeonColors.neonCyan.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: NeonColors.neonCyan,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 0.6, end: 1.0, duration: 900.ms),
                const SizedBox(width: 6),
                const Text(
                  'LIQUID',
                  style: TextStyle(
                    color: NeonColors.neonCyan,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
