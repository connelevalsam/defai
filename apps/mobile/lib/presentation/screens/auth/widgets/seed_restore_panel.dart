/*
* Created by Connel Asikong on 16/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/widgets/button_widget.dart';
import '../../../../utils/defai_themes.dart';

class SeedRestorePanel extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const SeedRestorePanel({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.obscure,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Warning banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Never share your seed phrase. DeFAI staff will never ask for it.',
                  style: TextStyle(
                    color: Colors.amber.withValues(alpha: 0.8),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Seed input
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          maxLines: obscure ? 1 : 4,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            height: 1.6,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            hintText: 'word1 word2 word3 ...',
            hintStyle: TextStyle(
              color: NeonColors.textGrey.withValues(alpha: 0.4),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            filled: true,
            fillColor: NeonColors.darkBg,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: NeonColors.neonPurple.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: NeonColors.neonPurple.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: NeonColors.neonPurple.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: NeonColors.textGrey,
                size: 18,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Restore button
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: isLoading ? 'RESTORING VAULT...' : 'RESTORE VAULT',
            onPressed: isLoading ? () {} : onSubmit,
            isSecondary: true,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0);
  }
}
