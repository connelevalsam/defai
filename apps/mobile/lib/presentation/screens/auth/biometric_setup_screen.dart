/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:defai/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/button_widget.dart';
import '../../../utils/defai_themes.dart';
import '../../../utils/storage_keys.dart';

enum _ScreenMode { setup, unlock }

enum _GateState { idle, authenticating, success, error }

class BiometricGateScreen extends ConsumerStatefulWidget {
  const BiometricGateScreen({super.key});

  @override
  ConsumerState createState() => _BiometricGateScreenState();
}

class _BiometricGateScreenState extends ConsumerState<BiometricGateScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  _ScreenMode _mode = _ScreenMode.unlock;
  _GateState _state = _GateState.idle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _determineMode();
  }

  Future<void> _determineMode() async {
    final biometricSet = await StorageService().getKey(
      StorageKeys.biometricEnabled,
    );
    if (!mounted) return;
    setState(() {
      _mode = biometricSet == null ? _ScreenMode.setup : _ScreenMode.unlock;
    });
    // Auto-trigger for returning users
    if (_mode == _ScreenMode.unlock) _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() {
      _state = _GateState.authenticating;
      _errorMessage = null;
    });

    try {
      final canAuth =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

      if (!canAuth) {
        if (!mounted) return;
        setState(() {
          _state = _GateState.error;
          _errorMessage = 'No security method available on this device.';
        });
        return;
      }

      final success = await _auth.authenticate(
        localizedReason: _mode == _ScreenMode.setup
            ? 'Register your biometric to secure DeFAI'
            : 'Unlock your DeFAI Vault',
        biometricOnly: false,
      );

      if (!mounted) return;

      if (success) {
        if (_mode == _ScreenMode.setup) {
          await StorageService().saveKey(StorageKeys.biometricEnabled, 'true');
          if (!mounted) return;
        }
        setState(() => _state = _GateState.success);
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;

        ref.read(authProvider.notifier).completeRegistration();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/dashboard');
        });
      } else {
        // Cancelled silently — let user retry
        setState(() => _state = _GateState.idle);
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _GateState.error;
        _errorMessage = _friendlyError(e.code);
      });
    }
  }

  Future<void> _skipBiometric() async {
    await StorageService().saveKey(StorageKeys.biometricEnabled, 'false');
    if (!mounted) return;
    ref.read(authProvider.notifier).completeRegistration();
    context.go('/dashboard');
  }

  String _friendlyError(String code) => switch (code) {
    'NotEnrolled' =>
      'No biometrics enrolled. Set up Face ID or fingerprint in settings, or skip to use PIN.',
    'LockedOut' => 'Too many attempts. Biometric temporarily locked.',
    'PermanentlyLockedOut' => 'Biometric permanently locked. Use device PIN.',
    _ => 'Authentication unavailable. Try again or skip.',
  };

  @override
  Widget build(BuildContext context) {
    final color = switch (_state) {
      _GateState.success => Colors.greenAccent,
      _GateState.error => NeonColors.neonPink,
      _ => NeonColors.neonCyan,
    };

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: appPadding),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              NeonColors.neonCyan.withValues(alpha: 0.5),
              NeonColors.darkBg,
            ],
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _state == _GateState.authenticating
                  ? SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        color: NeonColors.neonCyan,
                        strokeWidth: 1.5,
                      ),
                    )
                  : HugeIcon(
                          icon: _state == _GateState.success
                              ? HugeIcons.strokeRoundedCheckmarkCircle01
                              : _state == _GateState.error
                              ? HugeIcons.strokeRoundedAlertCircle
                              : HugeIcons.strokeRoundedShield01,

                          color: color,
                          size: 80,
                        )
                        .animate(
                          key: ValueKey('icon_$_state'),
                          onPlay: (c) => _state == _GateState.idle
                              ? c.repeat()
                              : c.forward(),
                        )
                        .shimmer(
                          duration: 2.seconds,
                          color: color.withValues(alpha: 0.3),
                        ),

              const SizedBox(height: 32),

              Text(
                    _state == _GateState.success
                        ? "UNLOCKED"
                        : _state == _GateState.error
                        ? "AUTH FAILED"
                        : _state == _GateState.authenticating
                        ? "AUTHENTICATING..."
                        : _mode == _ScreenMode.setup
                        ? "SECURE YOUR VAULT"
                        : "VAULT LOCKED",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  )
                  .animate(key: ValueKey('title_$_state'))
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 12),

              Text(
                switch (_state) {
                  _GateState.success => 'Sentinel is ready.',
                  _GateState.authenticating =>
                    'Securely verifying your identity...',
                  _GateState.error =>
                    _errorMessage ?? 'Tap below to try again.',
                  _ =>
                    _mode == _ScreenMode.setup
                        ? 'Register your biometric to enable the Sovereign Handshake.'
                        : 'Authenticate to access your DeFAI vault.',
                },
                style: TextStyle(
                  color: NeonColors.textGrey,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate(key: ValueKey('sub_$_state')).fadeIn(duration: 300.ms),

              // Error card
              if (_errorMessage != null && _state == _GateState.error) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeonColors.neonPink.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: NeonColors.neonPink.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: NeonColors.neonPink,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: NeonColors.textGrey,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).shakeX(hz: 3, amount: 4),
              ],

              const SizedBox(height: 60),

              NeonButton(
                isSecondary: true,
                label: switch (_state) {
                  _GateState.authenticating => 'AUTHENTICATING...',
                  _GateState.success => 'UNLOCKED ✓',
                  _GateState.error => 'TRY AGAIN',
                  _ =>
                    _mode == _ScreenMode.setup
                        ? 'ENABLE BIOMETRIC'
                        : 'UNLOCK WITH BIOMETRICS',
                },
                onPressed: _state == _GateState.authenticating
                    ? () {}
                    : _authenticate,
              ),

              const SizedBox(height: 16),

              // Skip — only shown during first-time setup
              if (_mode == _ScreenMode.setup)
                TextButton(
                  onPressed: _skipBiometric,
                  child: const Text(
                    'Skip — use device PIN only',
                    style: TextStyle(
                      color: NeonColors.textGrey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: NeonColors.textGrey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
