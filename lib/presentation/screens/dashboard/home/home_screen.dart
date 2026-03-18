/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/button_widget.dart';
import '../../../../utils/defai_themes.dart';
import 'widgets/balance_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header with Wallet Balances
              BalanceCard(
                asset: "USD₮",
                amount: "5,240.50",
                color: NeonColors.neonCyan,
              ),
              const SizedBox(height: 16),
              BalanceCard(
                asset: "XAU₮",
                amount: "12.04",
                color: NeonColors.neonPurple,
              ),

              const SizedBox(height: 40),

              // The Central Agent Pulse
              Center(
                child: Column(
                  children: [
                    // const AgentCoreWidget(), // Custom pulse animation
                    const SizedBox(height: 16),
                    Text(
                      "AGENT STATUS: MONITORING",
                      style: TextStyle(
                        color: NeonColors.neonCyan,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Action Button
              NeonButton(
                label: "Execute New Strategy",
                onPressed: () => context.push('/agent-setup'),
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
