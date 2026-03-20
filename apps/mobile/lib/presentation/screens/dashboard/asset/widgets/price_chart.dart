/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class PriceChart extends StatelessWidget {
  final Asset asset;

  const PriceChart({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 16, right: 8),
      decoration: BoxDecoration(
        color: NeonColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: asset.color.withValues(alpha: 0.1),
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => NeonColors.surface,
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                s.y.toStringAsFixed(4),
                TextStyle(
                  color: asset.color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ))
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: asset.chartData,
              isCurved: true,
              color: asset.color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    asset.color.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
