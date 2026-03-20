/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class ReceiveSheet extends StatelessWidget {
  final Asset asset;

  const ReceiveSheet({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: NeonColors.textGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'RECEIVE ${asset.symbol}',
            style: TextStyle(
              color: asset.color,
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Address display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeonColors.darkBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: asset.color.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    asset.address, // TODO: real WDK address
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: asset.address));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${asset.symbol} address copied'),
                        backgroundColor: NeonColors.surface,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy_outlined,
                    color: asset.color,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Only send ${asset.symbol} to this address on the Liquid network.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NeonColors.textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
