/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:defai/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/defai_themes.dart';
import '../utils/global.dart';
import '../utils/storage_keys.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for splash animation to play out
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    // Read onboarding state AFTER delay — provider is stable by now
    final isDone = await StorageService().getKey(
      StorageKeys.onboardingComplete,
    );
    if (!mounted) return;

    isDone == 'true' ? context.go('/login') : context.go('/onboarding');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phoneHeight = MediaQuery.sizeOf(context).height;
    phoneWidth = MediaQuery.sizeOf(context).width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield Icon with a glow
            Container(
                  clipBehavior: Clip.hardEdge,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: NeonColors.neonCyan, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: NeonColors.neonCyan.withValues(alpha: 0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: NeonColors.neonCyan,
                    size: 60,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scaleXY(begin: 0.6, end: 1.0, curve: Curves.easeOutBack)
                .then()
                .shimmer(
                  duration: 1800.ms,
                  color: Colors.white.withValues(alpha: 0.7),
                ),

            /*.animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1200.ms, color: Colors.white)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(0.8, 0.8),
                ),*/
            const SizedBox(height: 24),

            Text(
                  "DeFAI",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
            // .blur(begin: const Offset(10, 10), end: Offset.zero),
            const SizedBox(height: 8),

            Text(
              'SOVEREIGN FINANCE AGENT',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 4,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
          ],
        ),
      ),
      /*.animate(
            onComplete: (_) {
              final done = ref.read(onboardingControllerProvider);
              Future.delayed(Duration(seconds: 3), () {
                if (mounted) {
                  // ref.read(splashCompleteProvider.notifier).complete();
                }
                if (context.mounted) {
                  done ? context.go('/login') : context.go('/onboarding');
                }
              });
            },
          ),*/
    );
  }
}
