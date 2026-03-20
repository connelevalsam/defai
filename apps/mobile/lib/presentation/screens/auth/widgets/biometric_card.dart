/*
* Created by Connel Asikong on 16/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../utils/defai_themes.dart';

class BiometricCard extends StatelessWidget {
  const BiometricCard({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: NeonColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NeonColors.neonCyan.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: NeonColors.neonCyan.withValues(alpha: 0.06),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Fingerprint icon
                isLoading
                    ? SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          color: NeonColors.neonCyan,
                          strokeWidth: 1.5,
                        ),
                      )
                    : HugeIcon(
                            icon: HugeIcons.strokeRoundedFingerPrint,
                            color: NeonColors.neonCyan,
                            size: 56,
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scaleXY(
                            begin: 0.95,
                            end: 1.05,
                            duration: 1400.ms,
                            curve: Curves.easeInOut,
                          ),

                const SizedBox(height: 16),

                Text(
                  isLoading ? 'AUTHENTICATING...' : 'UNLOCK WITH BIOMETRICS',
                  style: TextStyle(
                    color: NeonColors.neonCyan,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Face ID · Touch ID · Device PIN',
                  style: TextStyle(color: NeonColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.15, end: 0);
  }
}
