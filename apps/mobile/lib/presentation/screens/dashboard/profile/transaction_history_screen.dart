/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:defai/core/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../utils/defai_themes.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  // Mock data — replace with real WDK event stream
  static const _txns = [
    Transaction(
      type: 'Auto-save',
      amount: '+12.50 USD₮',
      status: 'Confirmed',
      time: 'Today, 9:41 AM',
      hash: '0x7f3a...c91b',
      isPositive: true,
      color: NeonColors.neonCyan,
    ),
    Transaction(
      type: 'Gold conversion',
      amount: '+0.25 XAU₮',
      status: 'Confirmed',
      time: 'Today, 7:12 AM',
      hash: '0x2c18...a44d',
      isPositive: true,
      color: NeonColors.neonPurple,
    ),
    Transaction(
      type: 'Auto-save',
      amount: '+8.00 USD₮',
      status: 'Confirmed',
      time: 'Yesterday, 3:05 PM',
      hash: '0x9e41...f77c',
      isPositive: true,
      color: NeonColors.neonCyan,
    ),
    Transaction(
      type: 'Auto-save',
      amount: '+15.00 USD₮',
      status: 'Confirmed',
      time: 'Yesterday, 11:30 AM',
      hash: '0x4b22...d30e',
      isPositive: true,
      color: NeonColors.neonCyan,
    ),
    Transaction(
      type: 'Strategy aborted',
      amount: '—',
      status: 'Cancelled',
      time: 'Yesterday, 9:00 AM',
      hash: '—',
      isPositive: false,
      color: NeonColors.textGrey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      appBar: AppBar(
        backgroundColor: NeonColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: NeonColors.neonCyan,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'HISTORY',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: NeonColors.neonCyan.withValues(alpha: 0.1),
          ),
        ),
      ),
      body: _txns.isEmpty
          ? _buildEmpty(context)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _txns.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: NeonColors.neonCyan.withValues(alpha: 0.05),
                indent: 72,
              ),
              itemBuilder: (context, i) => _TxnRow(txn: _txns[i])
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 50 * i),
                    duration: 300.ms,
                  )
                  .slideX(begin: 0.05, end: 0),
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: NeonColors.textGrey.withValues(alpha: 0.3),
            size: 56,
          ),
          const SizedBox(height: 16),
          const Text(
            'No transactions yet',
            style: TextStyle(color: NeonColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Sentinel activity will appear here.',
            style: TextStyle(
              color: NeonColors.textGrey.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _TxnRow({required Transaction txn}) {
    return InkWell(
      onTap: txn.hash != '—' ? () => _showDetail(context, txn) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: txn.color.withValues(alpha: 0.08),
                border: Border.all(color: txn.color.withValues(alpha: 0.2)),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedAiBrain01,
                color: txn.color,
                size: 18,
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    txn.time,
                    style: const TextStyle(
                      color: NeonColors.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Amount + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  txn.amount,
                  style: TextStyle(
                    color: txn.isPositive
                        ? Colors.greenAccent
                        : NeonColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: txn.status == 'Confirmed'
                        ? Colors.greenAccent.withValues(alpha: 0.08)
                        : NeonColors.textGrey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    txn.status,
                    style: TextStyle(
                      color: txn.status == 'Confirmed'
                          ? Colors.greenAccent
                          : NeonColors.textGrey,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Transaction txn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: NeonColors.textGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              txn.type.toUpperCase(),
              style: TextStyle(
                color: txn.color,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Amount', value: txn.amount),
            _DetailRow(label: 'Status', value: txn.status),
            _DetailRow(label: 'Time', value: txn.time),
            _DetailRow(label: 'TX Hash', value: txn.hash, mono: true),
            const SizedBox(height: 16),
            if (txn.hash != '—')
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: txn.hash));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hash copied'),
                      backgroundColor: NeonColors.surface,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: NeonColors.neonCyan.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: NeonColors.neonCyan.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'COPY TX HASH',
                      style: TextStyle(
                        color: NeonColors.neonCyan,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _DetailRow({
    required String label,
    required String value,
    bool mono = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: NeonColors.textGrey, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
