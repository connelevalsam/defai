/*
* Created by Connel Asikong on 13/03/2026
*
*/

import 'package:defai/core/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/identity_service.dart';
import '../../../utils/defai_themes.dart';
import '../../../utils/global.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: appPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Your Identity", style: theme.textTheme.displaySmall),
            const SizedBox(height: 48),
            NeonButton(
              onPressed: () async {
                final mnemonic = ref
                    .read(identityServiceProvider)
                    .generateMnemonic();

                if (context.mounted) {
                  context.go('/seed-backup', extra: mnemonic);
                }
              },
              label: 'GENERATE SECURE IDENTITY',
            ),
            // ── Login button ────────────────────────────────────
            const SizedBox(height: 34),
            Center(
              child: GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: NeonColors.textGrey),
                    children: [
                      const TextSpan(text: 'Already have a vault? '),
                      TextSpan(
                        text: 'Login then.',
                        style: TextStyle(
                          color: NeonColors.neonCyan,
                          decoration: TextDecoration.underline,
                          decorationColor: NeonColors.neonCyan,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
