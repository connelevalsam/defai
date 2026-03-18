/*
* Created by Connel Asikong on 13/03/2026
*
*/

import 'package:defai/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/storage_service.dart';

class SeedVerifyScreen extends ConsumerStatefulWidget {
  final String mnemonic;
  const SeedVerifyScreen({super.key, required this.mnemonic});

  @override
  ConsumerState<SeedVerifyScreen> createState() => _SeedVerifyScreenState();
}

class _SeedVerifyScreenState extends ConsumerState<SeedVerifyScreen> {
  late List<String> _correctOrder;
  late List<String> _scrambledWords;
  List<String> _selectedWords = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _correctOrder = widget.mnemonic.split(' ');
    _scrambledWords = List.from(_correctOrder)..shuffle();
  }

  void _onWordTap(String word) {
    if (_isProcessing) return;

    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
        _scrambledWords.add(word);
      } else {
        _selectedWords.add(word);
        _scrambledWords.remove(word);
      }
    });
  }

  /*void _finishRegistration() async {
    final mnemonic = widget.mnemonic;

    await StorageService().saveKey('vault_mnemonic', mnemonic);

    ref.read(authProvider.notifier).completeRegistration();

    if (mounted) {
      context.go('/dashboard');
    }
  }*/

  Future<void> _finalizeVault() async {
    setState(() => _isProcessing = true);

    try {
      // 1. Save the mnemonic securely — NOT a derived key
      await StorageService().saveMnemonic(widget.mnemonic);

      // 2. Init vault via Rust bridge (WDK)
      // This consumes the mnemonic inside Rust — Dart never holds keys
      // final vault = initWallet(mnemonic: widget.mnemonic);
      // await StorageService().saveKey(StorageKeys.vaultAddress, vault.address);

      // 3. Mark registration complete
      ref.read(authProvider.notifier).completeRegistration();

      // 4. Go to biometric SETUP (not dashboard — user must enroll biometrics first)
      if (mounted) context.go('/biometric');
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Vault creation failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isValid = _selectedWords.join(' ') == widget.mnemonic;

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Seed")),
      body: Column(
        children: [
          // The Selection Area
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedWords.isEmpty
                ? Center(
                    child: Text(
                      'Tap words below in order',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    children: _selectedWords
                        .map(
                          (w) => Chip(
                            label: Text(w),
                            onDeleted: () => _onWordTap(w),
                          ),
                        )
                        .toList(),
                  ),
          ),
          // The Word Bank
          Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            child: Wrap(
              spacing: 8,
              children: _scrambledWords
                  .map(
                    (w) => ActionChip(
                      label: Text(w),
                      onPressed: () => _onWordTap(w),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: isValid && !_isProcessing ? _finalizeVault : null,
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('SECURE MY VAULT'),
            ),
          ),
          SizedBox(height: phoneHeight * .02),
        ],
      ),
    );
  }
}
