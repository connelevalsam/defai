/*
* Created by Connel Asikong on 20/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../utils/defai_themes.dart';

class SkeletonCard extends StatelessWidget {
  final Color color;

  const SkeletonCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 80,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NeonColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 1200.ms, color: color.withValues(alpha: 0.05));
  }
}
