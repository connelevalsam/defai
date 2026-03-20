/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class AssetDetails extends StatelessWidget {
  final Asset asset;

  const AssetDetails({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.name,
                style: const TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: asset.balance,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: '  ${asset.symbol}',
                      style: TextStyle(
                        color: asset.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                asset.fiatValue,
                style: const TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          // 24h change badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: asset.isPositive
                  ? Colors.greenAccent.withValues(alpha: 0.08)
                  : NeonColors.neonPink.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: asset.isPositive
                    ? Colors.greenAccent.withValues(alpha: 0.3)
                    : NeonColors.neonPink.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  asset.isPositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: asset.isPositive
                      ? Colors.greenAccent
                      : NeonColors.neonPink,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  asset.change24h,
                  style: TextStyle(
                    color: asset.isPositive
                        ? Colors.greenAccent
                        : NeonColors.neonPink,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
