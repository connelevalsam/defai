/*
* Created by Connel Asikong on 15/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../utils/defai_themes.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              )
              .animate(key: ValueKey(message))
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
    );
  }
}
