/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';
import 'action_button.dart';
import 'receive_sheet.dart';
import 'send_sheet.dart';

class SendReceiveRow extends StatelessWidget {
  final Asset asset;

  const SendReceiveRow({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              label: 'RECEIVE',
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: NeonColors.neonCyan,
              onTap: () => _showReceiveSheet(context, asset),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              label: 'SEND',
              icon: HugeIcons.strokeRoundedArrowUp01,
              color: NeonColors.neonPurple,
              onTap: () => _showSendSheet(context, asset),
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiveSheet(BuildContext context, Asset asset) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ReceiveSheet(asset: asset),
    );
  }

  void _showSendSheet(BuildContext context, Asset asset) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SendSheet(asset: asset),
    );
  }
}
