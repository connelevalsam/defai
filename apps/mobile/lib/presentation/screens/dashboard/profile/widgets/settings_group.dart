/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../utils/defai_themes.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: NeonColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.neonCyan.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  color: NeonColors.neonCyan.withValues(alpha: 0.05),
                  indent: 52,
                ),
            ],
          );
        }),
      ),
    );
  }
}
