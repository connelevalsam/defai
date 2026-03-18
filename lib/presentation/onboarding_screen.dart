/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:cb_intros/cb_intros.dart';
import 'package:defai/core/services/storage_service.dart';
import 'package:defai/utils/defai_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../utils/storage_keys.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final List<Widget> bgDisplay = [
    HugeIcon(
      icon: HugeIcons.strokeRoundedShield01,
      size: 200,
      color: NeonColors.neonCyan,
    ),

    HugeIcon(
      icon: HugeIcons.strokeRoundedAiBrain01,
      size: 200,
      color: NeonColors.neonPink,
    ),

    HugeIcon(
      icon: HugeIcons.strokeRoundedFingerPrint,
      size: 200,
      color: NeonColors.neonPurple,
    ),
  ];

  final List<String> title = [
    "Your Keys.\nYour Wealth.",
    "Sentinel\nNever Sleeps.",
    "You Approve.\nSentinel Executes.",
  ];
  final List<String> desc = [
    "DeFAI generates and stores your vault seed locally using Tether WDK. No server ever touches your private keys.",
    "Deploy AI strategies that monitor markets, rebalance assets, and settle in USD₮ or XAU₮ — 24/7, without you watching.",
    "Every transaction requires your biometric signature. Full transparency. Full control. True sovereignty.",
  ];
  final List<Color> colors = [Colors.black, Colors.black87, Colors.black54];

  final List<List<Effect>> animationEffects = [
    [
      const TintEffect(
        delay: Duration(seconds: 1),
        duration: Duration(seconds: 1),
        begin: 0.9,
        end: 0,
      ),
    ],
    [
      const FadeEffect(
        delay: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      ),
    ],
    [
      const BlurEffect(
        delay: Duration(seconds: 1),
        begin: Offset.zero,
        end: Offset(10, 10),
      ),
    ],
  ];

  Future<void> moveToNextScreen() async {
    await StorageService().saveKey(StorageKeys.onboardingComplete, 'true');
    if (mounted) context.go('/registration');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CbIntros(
        items: bgDisplay,
        colors: colors,
        titles: title,
        desc: desc,
        moveToNextScreen: moveToNextScreen,
        boxHeight: 350,
        appPadding: 20,
        btnColor: Theme.of(context).primaryColor,
        boxColor: Colors.blueGrey,
        titleContainer: (BuildContext context, String content) {
          return Text(
            content,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.grey.shade200,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        },
        descContainer: (BuildContext context, String content) {
          return Text(
            content,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        },
        animationEffects: animationEffects,
      ),
    );
  }
}
