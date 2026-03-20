/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';

class ToggleRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool value;
  final void Function(bool) onToggle;

  const ToggleRow({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onToggle,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: NeonColors.textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onToggle,
            activeThumbColor: NeonColors.neonCyan,
            activeTrackColor: NeonColors.neonCyan.withValues(alpha: 0.3),
            inactiveThumbColor: NeonColors.textGrey,
            inactiveTrackColor: NeonColors.textGrey.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
