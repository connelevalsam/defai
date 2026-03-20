/*
* Created by Connel Asikong on 19/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../utils/defai_themes.dart';

class WipeDialog extends StatelessWidget {
  const WipeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NeonColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Wipe Vault?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'This will permanently delete your vault keys and all local data. '
        'Make sure you have your seed phrase backed up — this cannot be undone.',
        style: TextStyle(color: NeonColors.textGrey, height: 1.5, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'CANCEL',
            style: TextStyle(color: NeonColors.textGrey, letterSpacing: 1),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'WIPE',
            style: TextStyle(
              color: NeonColors.neonPink,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
