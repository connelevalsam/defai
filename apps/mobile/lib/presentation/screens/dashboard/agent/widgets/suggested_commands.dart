/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';

class SuggestedCommands extends StatelessWidget {
  const SuggestedCommands({super.key, required this.onTap});

  final void Function(String) onTap;

  static const _suggestions = [
    'Save 10% of every incoming USD₮',
    'Convert to XAU₮ when balance exceeds 1,000',
    'Keep 500 USD₮ as minimum reserve',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK STRATEGIES',
          style: TextStyle(
            color: NeonColors.textGrey.withValues(alpha: 0.5),
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        ..._suggestions.map(
          (s) => GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: NeonColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: NeonColors.neonCyan.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedBulbCharging,
                    size: 14,
                    color: NeonColors.neonCyan.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        color: NeonColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: NeonColors.textGrey.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
