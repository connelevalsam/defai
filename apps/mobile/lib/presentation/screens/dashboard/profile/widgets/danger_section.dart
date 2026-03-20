/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';

class DangerSection extends StatelessWidget {
  final VoidCallback onWipe;

  const DangerSection({super.key, required this.onWipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: NeonColors.neonPink.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.neonPink.withValues(alpha: 0.15)),
      ),
      child: GestureDetector(
        onTap: onWipe,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedDelete01,
                color: NeonColors.neonPink,
                size: 20,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wipe vault',
                      style: TextStyle(
                        color: NeonColors.neonPink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Permanently delete all keys and data',
                      style: TextStyle(
                        color: NeonColors.textGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: NeonColors.neonPink.withValues(alpha: 0.5),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
