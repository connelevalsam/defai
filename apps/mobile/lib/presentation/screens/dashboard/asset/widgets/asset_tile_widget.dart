/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../utils/defai_themes.dart';

class AssetTileWidget extends StatelessWidget {
  const AssetTileWidget({
    super.key,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String name, symbol, amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                symbol,
                style: const TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
