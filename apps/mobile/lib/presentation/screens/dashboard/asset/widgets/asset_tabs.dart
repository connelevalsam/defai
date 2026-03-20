/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class AssetTabs extends StatelessWidget {
  final List<Asset> assets;
  final int selectedIndex;
  final void Function(int) onSelect;

  const AssetTabs({
    super.key,
    required this.assets,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(assets.length, (i) {
          final isSelected = i == selectedIndex;
          final asset = assets[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(right: i < assets.length - 1 ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? asset.color.withValues(alpha: 0.1)
                      : NeonColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? asset.color.withValues(alpha: 0.5)
                        : NeonColors.neonCyan.withValues(alpha: 0.06),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    HugeIcon(
                      icon: asset.icon,
                      color: isSelected ? asset.color : NeonColors.textGrey,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.symbol,
                      style: TextStyle(
                        color: isSelected ? asset.color : NeonColors.textGrey,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
