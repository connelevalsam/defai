/*
* Created by Connel Asikong on 16/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../utils/defai_themes.dart';

class RestoreToggle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const RestoreToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: NeonColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded
                ? NeonColors.neonPurple.withValues(alpha: 0.4)
                : NeonColors.neonCyan.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedKey01,
              color: isExpanded ? NeonColors.neonPurple : NeonColors.textGrey,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Restore from seed phrase',
                style: TextStyle(
                  color: isExpanded
                      ? NeonColors.neonPurple
                      : NeonColors.textGrey,
                  fontSize: 13,
                  fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: isExpanded ? 0.5 : 0,
                ),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: NeonColors.textGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
