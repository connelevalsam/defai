/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../utils/defai_themes.dart';

class ReasoningStep extends StatelessWidget {
  const ReasoningStep({
    super.key,
    required this.index,
    required this.text,
    required this.isActive,
    required this.isDone,
    required this.isLast,
  });

  final int index;
  final String text;
  final bool isActive;
  final bool isDone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? Colors.greenAccent
        : isActive
        ? NeonColors.neonCyan
        : NeonColors.textGrey;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator column
          Column(
            children: [
              // Circle
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                  border: Border.all(
                    color: color.withValues(alpha: isDone ? 1 : 0.5),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check, size: 12, color: color)
                      : isActive
                      ? Container(
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
                            .scaleXY(begin: 0.6, end: 1.0, duration: 600.ms)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              // Vertical connector
              if (!isLast)
                Container(
                  width: 1,
                  height: 12,
                  color: color.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Step text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: TextStyle(
                  color: isDone
                      ? NeonColors.textGrey
                      : isActive
                      ? Colors.white
                      : NeonColors.textGrey.withValues(alpha: 0.5),
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
