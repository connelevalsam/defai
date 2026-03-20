/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/asset.dart';
import '../../../../utils/defai_themes.dart';
import 'widgets/all_assets_list.dart';
import 'widgets/asset_details.dart';
import 'widgets/asset_tabs.dart';
import 'widgets/price_chart.dart';
import 'widgets/send_receive_row.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  AssetScreenState createState() => AssetScreenState();
}

class AssetScreenState extends ConsumerState<AssetScreen> {
  int _selectedAsset = 0;

  @override
  Widget build(BuildContext context) {
    final asset = assets[_selectedAsset];

    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Asset selector tabs ──────────────────────────────────
                    AssetTabs(
                      assets: assets,
                      selectedIndex: _selectedAsset,
                      onSelect: (i) => setState(() => _selectedAsset = i),
                    ),

                    const SizedBox(height: 8),

                    // ── Selected asset detail ────────────────────────────────
                    AssetDetails(asset: asset)
                        .animate(key: ValueKey('detail_$_selectedAsset'))
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.05, end: 0),

                    // ── Price chart ──────────────────────────────────────────
                    PriceChart(asset: asset)
                        .animate(key: ValueKey('chart_$_selectedAsset'))
                        .fadeIn(duration: 400.ms),

                    // ── Send / Receive ───────────────────────────────────────
                    SendReceiveRow(asset: asset),

                    const SizedBox(height: 24),

                    // ── All assets list ──────────────────────────────────────
                    AllAssetsList(
                      assets: assets,
                      selectedIndex: _selectedAsset,
                      onSelect: (i) => setState(() => _selectedAsset = i),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Text(
            'VAULT',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Total portfolio value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'TOTAL VALUE',
                style: TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 9,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '\$21,630.50', // TODO: sum from WDK
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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
