/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../utils/defai_themes.dart';

class VaultCard extends StatelessWidget {
  final String address;
  final BuildContext ctx;

  const VaultCard({super.key, required this.address, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeonColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NeonColors.neonCyan.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: NeonColors.neonCyan.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeonColors.neonCyan.withValues(alpha: 0.08),
                  border: Border.all(
                    color: NeonColors.neonCyan.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.bolt,
                  color: NeonColors.neonCyan,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DeFAI VAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Self-custodial · Liquid Network',
                    style: TextStyle(color: NeonColors.textGrey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Address row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NeonColors.darkBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: NeonColors.neonCyan.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    ScaffoldMessenger.of(
                      // ignore: use_build_context_synchronously
                      ctx,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied'),
                        backgroundColor: NeonColors.surface,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy_outlined,
                    color: NeonColors.neonCyan,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
