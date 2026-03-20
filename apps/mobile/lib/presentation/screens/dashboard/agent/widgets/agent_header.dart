/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/providers/agent_provider.dart';
import '../../../../../utils/defai_themes.dart';
import 'agent_status_chip.dart';

class AgentHeader extends StatelessWidget {
  const AgentHeader({super.key, required this.status});

  final AgentStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          SafeArea(
            child: Text(
              'SENTINEL',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NeonColors.neonCyan,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          AgentStatusChip(status: status),
        ],
      ),
    );
  }
}
