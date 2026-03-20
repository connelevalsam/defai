/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';

class BalanceCard extends StatelessWidget {
  final String asset;
  final String amount;
  final Color color;
  final List<List<dynamic>> icon;

  const BalanceCard({
    super.key,
    required this.asset,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeonColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, color: color, size: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                asset,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
    ;
  }
}
