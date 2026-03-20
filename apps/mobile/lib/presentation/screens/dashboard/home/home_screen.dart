/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/providers/agent_provider.dart';
import '../../../../utils/defai_themes.dart';
import 'widgets/agent_pulse_section.dart';
import 'widgets/balance_section.dart';
import 'widgets/home_app_bar.dart';

// ── Mock activity log (replace with real WDK data later) ─────────────────────

class _ActivityItem {
  final String description;
  final String amount;
  final String asset;
  final String timeAgo;
  final bool isPositive;
  final List<List<dynamic>> icon;
  final Color color;

  const _ActivityItem({
    required this.description,
    required this.amount,
    required this.asset,
    required this.timeAgo,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

final _mockActivity = [
  _ActivityItem(
    description: 'Auto-save executed',
    amount: '+12.50',
    asset: 'USD₮',
    timeAgo: '2m ago',
    isPositive: true,
    icon: HugeIcons.strokeRoundedSavings,
    color: NeonColors.neonCyan,
  ),
  _ActivityItem(
    description: 'Balance check',
    amount: '—',
    asset: '',
    timeAgo: '17m ago',
    isPositive: true,
    icon: HugeIcons.strokeRoundedAnalytics01,
    color: NeonColors.textGrey,
  ),
  _ActivityItem(
    description: 'Gold threshold triggered',
    amount: '+0.25',
    asset: 'XAU₮',
    timeAgo: '2h ago',
    isPositive: true,
    icon: HugeIcons.strokeRoundedBitcoin02,
    color: NeonColors.neonPurple,
  ),
  _ActivityItem(
    description: 'Auto-save executed',
    amount: '+8.00',
    asset: 'USD₮',
    timeAgo: '3h ago',
    isPositive: true,
    icon: HugeIcons.strokeRoundedSavings,
    color: NeonColors.neonCyan,
  ),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentState = ref.watch(agentProvider);
    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeAppBar(agentState: agentState)),
            SliverToBoxAdapter(
              child: AgentPulseSection(agentState: agentState),
            ),
            SliverToBoxAdapter(child: BalanceSection()),
            // ── Activity feed ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: NeonColors.neonCyan,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: NeonColors.neonCyan.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'SENTINEL ACTIVITY',
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
            ),

            // List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _mockActivity[index];
                return _activityFeed(item: item)
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 60 * index),
                      duration: 300.ms,
                    )
                    .slideX(begin: 0.05, end: 0);
              }, childCount: _mockActivity.length),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _activityFeed({required _ActivityItem item}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.color.withValues(alpha: 0.08),
              border: Border.all(color: item.color.withValues(alpha: 0.2)),
            ),
            child: HugeIcon(icon: item.icon, color: item.color, size: 16),
          ),

          const SizedBox(width: 12),

          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.timeAgo,
                  style: const TextStyle(
                    color: NeonColors.textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          if (item.amount != '—')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.amount,
                  style: TextStyle(
                    color: item.color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.asset,
                  style: const TextStyle(
                    color: NeonColors.textGrey,
                    fontSize: 10,
                  ),
                ),
              ],
            )
          else
            Text(
              'Monitoring',
              style: TextStyle(
                color: NeonColors.textGrey.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
