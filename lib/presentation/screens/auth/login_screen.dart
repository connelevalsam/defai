/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/identity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../utils/defai_themes.dart';
import 'widgets/biometric_card.dart';
import 'widgets/error_banner.dart';
import 'widgets/restore_toggle.dart';
import 'widgets/seed_restore_panel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _seedController = TextEditingController();
  final _focusNode = FocusNode();

  bool _showRestore = false;
  bool _isLoading = false;
  bool _obscureSeed = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric on load — returning user expects this
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlockWithBiometric());
  }

  @override
  void dispose() {
    _seedController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Biometric unlock ───────────────────────────────────────────────────────

  Future<void> _unlockWithBiometric() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref
        .read(authProvider.notifier)
        .unlockWithBiometrics();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      context.go('/dashboard');
    } else {
      setState(() => _errorMessage = 'Biometric authentication failed.');
    }
  }

  // ── Seed phrase restore ────────────────────────────────────────────────────

  Future<void> _restoreFromSeed() async {
    print('Hello');
    final mnemonic = _seedController.text.trim();

    // Validate word count
    final words = mnemonic.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length != 12 && words.length != 24) {
      setState(
        () => _errorMessage = 'Please enter a valid 12 or 24-word seed phrase.',
      );
      return;
    }

    // Validate mnemonic checksum
    final isValid = ref
        .read(identityServiceProvider)
        .validateMnemonic(mnemonic);
    if (!isValid) {
      setState(
        () => _errorMessage =
            'Invalid seed phrase. Check your words and try again.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Save restored mnemonic — same path as fresh registration
      await StorageService().saveMnemonic(mnemonic);

      // TODO: call Rust bridge to reinitialise WDK vault
      // final vault = initWallet(mnemonic: mnemonic);
      // await StorageService().saveKey(StorageKeys.vaultAddress, vault.address);

      if (!mounted) return;

      ref.read(authProvider.notifier).completeRegistration();
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Restore failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // ── Header ───────────────────────────────────────────────
                  _buildHeader(context),

                  const Spacer(),

                  // ── Biometric Card ────────────────────────────────────────
                  BiometricCard(
                    isLoading: _isLoading && !_showRestore,
                    onTap: _unlockWithBiometric,
                  ),

                  const SizedBox(height: 16),

                  // ── Error message ─────────────────────────────────────────
                  if (_errorMessage != null)
                    ErrorBanner(message: _errorMessage!),

                  if (_errorMessage != null) const SizedBox(height: 16),

                  // ── Divider ───────────────────────────────────────────────
                  _buildDivider(),

                  const SizedBox(height: 16),

                  // ── Restore toggle ────────────────────────────────────────
                  RestoreToggle(
                    isExpanded: _showRestore,
                    onToggle: () {
                      setState(() {
                        _showRestore = !_showRestore;
                        _errorMessage = null;
                      });
                      if (_showRestore) {
                        Future.delayed(
                          const Duration(milliseconds: 300),
                        ).then((_) => _focusNode.requestFocus());
                      }
                    },
                  ),

                  // ── Seed restore panel ────────────────────────────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _showRestore
                        ? SeedRestorePanel(
                            controller: _seedController,
                            focusNode: _focusNode,
                            obscure: _obscureSeed,
                            isLoading: _isLoading && _showRestore,
                            onToggleObscure: () =>
                                setState(() => _obscureSeed = !_obscureSeed),
                            onSubmit: _restoreFromSeed,
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo mark
        Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: NeonColors.neonCyan.withValues(alpha: 0.5),
                ),
                color: NeonColors.neonCyan.withValues(alpha: 0.06),
              ),
              child: const Icon(
                Icons.bolt,
                color: NeonColors.neonCyan,
                size: 26,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),

        const SizedBox(height: 24),

        Text(
              'VAULT ACCESS',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 8),

        Text(
          'Authenticate to unlock your Sentinel agent.',
          style: TextStyle(
            color: NeonColors.textGrey,
            fontSize: 14,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: NeonColors.neonCyan.withValues(alpha: 0.1)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: NeonColors.neonCyan.withValues(alpha: 0.1)),
        ),
      ],
    );
  }
}
