/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:defai/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/button_widget.dart';
import '../../../utils/defai_themes.dart';

class BiometricGateScreen extends StatefulWidget {
  const BiometricGateScreen({super.key});

  @override
  State<BiometricGateScreen> createState() => _BiometricGateScreenState();
}

class _BiometricGateScreenState extends State<BiometricGateScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: appPadding),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [NeonColors.neonCyan.withOpacity(0.1), NeonColors.darkBg],
            radius: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: NeonColors.neonCyan,
              size: 80,
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
            const SizedBox(height: 32),
            Text(
              "VAULT LOCKED",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              "Securely verifying your identity...",
              style: TextStyle(color: NeonColors.textGrey),
            ),
            const SizedBox(height: 60),
            Consumer(
              builder: (context, ref, child) {
                return NeonButton(
                  isSecondary: true,
                  label: "Unlock with Biometrics",
                  onPressed: () async {
                    final success = await ref
                        .read(authProvider.notifier)
                        .unlockWithBiometrics();
                    if (success && context.mounted) {
                      context.go('/dashboard');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
