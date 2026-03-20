/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class AllAssetsList extends StatelessWidget {
  final List<Asset> assets;
  final int selectedIndex;
  final void Function(int) onSelect;

  const AllAssetsList({
    super.key,
    required this.assets,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: NeonColors.neonCyan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ALL ASSETS',
                style: TextStyle(
                  color: NeonColors.neonCyan,
                  fontSize: 10,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(
          assets.length,
          (i) => GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: i == selectedIndex
                    ? assets[i].color.withValues(alpha: 0.04)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: NeonColors.neonCyan.withValues(alpha: 0.05),
                  ),
                  left: BorderSide(
                    color: i == selectedIndex
                        ? assets[i].color
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: assets[i].color.withValues(alpha: 0.08),
                      border: Border.all(
                        color: assets[i].color.withValues(alpha: 0.2),
                      ),
                    ),
                    child: HugeIcon(
                      icon: assets[i].icon,
                      color: assets[i].color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assets[i].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          assets[i].symbol,
                          style: const TextStyle(
                            color: NeonColors.textGrey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        assets[i].balance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        assets[i].change24h,
                        style: TextStyle(
                          color: assets[i].isPositive
                              ? Colors.greenAccent
                              : NeonColors.neonPink,
                          fontSize: 11,
                        ),
                      ),
                    ],
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
