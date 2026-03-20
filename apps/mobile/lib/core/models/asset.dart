/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../utils/defai_themes.dart';

class Asset {
  final String name;
  final String symbol;
  final String balance;
  final String fiatValue;
  final String change24h;
  final bool isPositive;
  final Color color;
  final List<List<dynamic>> icon;
  final List<FlSpot> chartData;
  final String address;

  const Asset({
    required this.name,
    required this.symbol,
    required this.balance,
    required this.fiatValue,
    required this.change24h,
    required this.isPositive,
    required this.color,
    required this.icon,
    required this.chartData,
    required this.address,
  });
}

// Mock data — replace with WDK provider when bridge is wired
final assets = [
  Asset(
    name: 'Tether USD',
    symbol: 'USD₮',
    balance: '12,450.00',
    fiatValue: '\$12,450.00',
    change24h: '+0.00%',
    isPositive: true,
    color: NeonColors.neonCyan,
    icon: HugeIcons.strokeRoundedDollarCircle,
    address: 'VJLx...k9mP',
    chartData: const [
      FlSpot(0, 1.0),
      FlSpot(1, 1.0),
      FlSpot(2, 1.001),
      FlSpot(3, 1.0),
      FlSpot(4, 1.0),
      FlSpot(5, 0.999),
      FlSpot(6, 1.0),
      FlSpot(7, 1.001),
      FlSpot(8, 1.0),
    ],
  ),
  Asset(
    name: 'Tether Gold',
    symbol: 'XAU₮',
    balance: '4.25',
    fiatValue: '\$9,180.50',
    change24h: '+1.24%',
    isPositive: true,
    color: NeonColors.neonPurple,
    icon: HugeIcons.strokeRoundedBitcoin02,
    address: 'VJLx...k9mP',
    chartData: const [
      FlSpot(0, 2.1),
      FlSpot(1, 2.3),
      FlSpot(2, 2.0),
      FlSpot(3, 2.5),
      FlSpot(4, 2.4),
      FlSpot(5, 2.8),
      FlSpot(6, 2.6),
      FlSpot(7, 2.9),
      FlSpot(8, 3.1),
    ],
  ),
  Asset(
    name: 'Tether USD',
    symbol: 'USD₮',
    balance: '10,450.00',
    fiatValue: '\$10,450.00',
    change24h: '+0.00%',
    isPositive: true,
    color: NeonColors.neonCyan,
    icon: HugeIcons.strokeRoundedDollarCircle,
    address: 'VJLx...k9mP',
    chartData: const [
      FlSpot(0, 1.0),
      FlSpot(1, 1.0),
      FlSpot(2, 1.001),
      FlSpot(3, 1.0),
      FlSpot(4, 1.0),
      FlSpot(5, 0.999),
      FlSpot(6, 1.0),
      FlSpot(7, 1.001),
      FlSpot(8, 1.0),
    ],
  ),
  Asset(
    name: 'Tether Gold',
    symbol: 'XAU₮',
    balance: '2.25',
    fiatValue: '\$9,180.50',
    change24h: '+1.24%',
    isPositive: true,
    color: NeonColors.neonPurple,
    icon: HugeIcons.strokeRoundedBitcoin02,
    address: 'VJLx...k9mP',
    chartData: const [
      FlSpot(0, 2.1),
      FlSpot(1, 2.3),
      FlSpot(2, 2.0),
      FlSpot(3, 2.5),
      FlSpot(4, 2.4),
      FlSpot(5, 2.8),
      FlSpot(6, 2.6),
      FlSpot(7, 2.9),
      FlSpot(8, 3.1),
    ],
  ),
];
