/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/defai_themes.dart';
import 'balance_card.dart';

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VAULT BALANCE',
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 10,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: BalanceCard(
                  asset: 'USD₮',
                  amount: '12,450.00', // TODO: ref.watch(walletProvider).usdt
                  color: NeonColors.neonCyan,
                  icon: HugeIcons.strokeRoundedDollarCircle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BalanceCard(
                  asset: 'XAU₮',
                  amount: '4.25', // TODO: ref.watch(walletProvider).xaut
                  color: NeonColors.neonPurple,
                  icon: HugeIcons.strokeRoundedBitcoin02,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
