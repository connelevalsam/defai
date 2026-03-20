/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';

class InfoRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;
  final Color color;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: color, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: NeonColors.textGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
