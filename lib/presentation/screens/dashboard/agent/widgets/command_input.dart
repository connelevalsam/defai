/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/widgets/button_widget.dart';
import '../../../../../utils/defai_themes.dart';

class CommandInput extends StatelessWidget {
  const CommandInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: NeonColors.neonPurple,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: NeonColors.neonPurple.withValues(alpha: 0.6),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'DEPLOY STRATEGY',
              style: TextStyle(
                color: NeonColors.neonPurple,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLines: 3,
          minLines: 2,
          onSubmitted: onSubmit,
          decoration: InputDecoration(
            hintText:
                'Describe your strategy in plain language...\ne.g. "Save 10% of every incoming USD₮"',
            hintStyle: TextStyle(
              color: NeonColors.textGrey.withValues(alpha: 0.5),
              fontSize: 13,
              height: 1.5,
            ),
            filled: true,
            fillColor: NeonColors.surface,
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
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: 'ACTIVATE SENTINEL',
            onPressed: () => onSubmit(controller.text),
            isSecondary: true,
          ),
        ),
      ],
    );
  }
}
