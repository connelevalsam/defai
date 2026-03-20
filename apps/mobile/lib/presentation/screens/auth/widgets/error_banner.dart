/*
* Created by Connel Asikong on 16/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/defai_themes.dart';

class ErrorBanner extends StatelessWidget {
  final String message;

  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: NeonColors.neonPink.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NeonColors.neonPink.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: NeonColors.neonPink, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: NeonColors.neonPink.withValues(alpha: 0.9),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).shakeX(hz: 3, amount: 4);
  }
}
