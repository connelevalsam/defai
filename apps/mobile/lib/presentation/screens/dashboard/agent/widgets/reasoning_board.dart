/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../utils/defai_themes.dart';
import 'reasoning_step.dart';

class ReasoningBoard extends StatelessWidget {
  const ReasoningBoard({
    super.key,
    required this.steps,
    required this.revealedCount,
    required this.isExecuting,
    required this.isSuccess,
  });

  final List<String> steps;
  final int revealedCount;
  final bool isExecuting;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Board header
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: NeonColors.neonCyan,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: NeonColors.neonCyan.withValues(alpha: 0.6),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'REASONING BOARD',
              style: TextStyle(
                color: NeonColors.neonCyan,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Steps container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeonColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: NeonColors.neonCyan.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            children: List.generate(steps.length, (i) {
              final isRevealed = i < revealedCount;
              final isCurrentlyActive =
                  i == revealedCount - 1 && !isExecuting && !isSuccess;
              final isDone = isExecuting || isSuccess || i < revealedCount - 1;

              if (!isRevealed) return const SizedBox.shrink();

              return ReasoningStep(
                index: i,
                text: steps[i],
                isActive: isCurrentlyActive,
                isDone: isDone,
                isLast: i == steps.length - 1,
              ).animate().fadeIn(duration: 350.ms).slideX(begin: -0.1, end: 0);
            }),
          ),
        ),
      ],
    );
  }
}
