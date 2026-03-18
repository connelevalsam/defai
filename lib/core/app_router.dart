/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:defai/presentation/screens/auth/biometric_setup_screen.dart';
import 'package:defai/presentation/screens/auth/login_screen.dart';
import 'package:defai/presentation/screens/dashboard/agent/agent_screen.dart';
import 'package:defai/presentation/screens/dashboard/asset/asset_screen.dart';
import 'package:defai/presentation/screens/dashboard/home/home_screen.dart';
import 'package:defai/presentation/screens/dashboard/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/error_screen.dart';
import '../presentation/onboarding_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/seed_backup_screen.dart';
import '../presentation/screens/auth/seed_verify_screen.dart';
import '../presentation/screens/indext_screen.dart';
import '../presentation/screens/widgets/privacy_guard.dart';
import '../presentation/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/seed-backup',
        builder: (context, state) {
          // Safely extract the mnemonic, providing an empty string or error state if null
          final mnemonic = state.extra as String? ?? "";

          if (mnemonic.isEmpty) {
            // In a real app, you'd redirect back or show an error
            return const ErrorScreen(message: "Seed phrase missing");
          }

          return SeedBackupScreen(mnemonic: mnemonic);
        },
      ),
      GoRoute(
        path: '/seed-verify',
        builder: (context, state) =>
            SeedVerifyScreen(mnemonic: state.extra as String),
      ),
      GoRoute(
        path: '/biometric',
        builder: (context, state) => BiometricGateScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PrivacyGuard(
            // Your custom blur logic lives here!
            child: IndexScreen(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/assets',
                builder: (context, state) => AssetScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/agents',
                builder: (context, state) => AgentScreen(),
                routes: [
                  /*GoRoute(
                    path: 'transaction',
                    builder: (context, state) {
                      final tx = state.extra;
                      return TransactionScreen(*/
                  /*tx: tx*/
                  /*);
                    },
                  ),*/
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pcorerofile',
                builder: (context, state) => ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'transaction',
                    builder: (context, state) {
                      final tx = state.extra;
                      return Scaffold(
                        appBar: AppBar(title: Text('Transaction')) /*tx: tx*/,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
