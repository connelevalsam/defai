/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/defai_themes.dart';
import 'widgets/asset_tile_widget.dart';

class AssetScreen extends ConsumerWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "VAULT ASSETS",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // The Neon Portfolio Chart
              Container(
                height: 200,
                padding: const EdgeInsets.only(top: 20, right: 20),
                decoration: BoxDecoration(
                  color: NeonColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LineChart(_mainData()),
              ),

              const SizedBox(height: 32),

              const Text(
                "ASSET ALLOCATION",
                style: TextStyle(
                  color: NeonColors.textGrey,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Tether USD Card
              AssetTileWidget(
                name: "Tether USD",
                symbol: "USD₮",
                amount: "12,450.00",
                color: NeonColors.neonCyan,
                icon: Icons.attach_money_rounded,
              ),
              const SizedBox(height: 12),

              // Tether Gold Card
              AssetTileWidget(
                name: "Tether Gold",
                symbol: "XAU₮",
                amount: "4.25",
                color: NeonColors.neonPurple,
                icon: Icons.brightness_high_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2, 2),
            FlSpot(4, 5),
            FlSpot(6, 3.5),
            FlSpot(8, 4.5),
            FlSpot(10, 4),
            FlSpot(12, 6),
          ],
          isCurved: true,
          color: NeonColors.neonCyan,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                NeonColors.neonCyan.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
