/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';

class Transaction {
  final String type;
  final String amount;
  final String status;
  final String time;
  final String hash;
  final bool isPositive;
  final Color color;

  const Transaction({
    required this.type,
    required this.amount,
    required this.status,
    required this.time,
    required this.hash,
    required this.isPositive,
    required this.color,
  });
}
