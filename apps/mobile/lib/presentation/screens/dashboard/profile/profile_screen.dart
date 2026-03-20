/*
* Created by Connel Asikong on 14/03/2026
*
*/

import 'package:defai/presentation/screens/dashboard/profile/widgets/wipe_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../utils/defai_themes.dart';
import '../../../../utils/storage_keys.dart';
import 'widgets/danger_section.dart';
import 'widgets/info_row.dart';
import 'widgets/settings_group.dart';
import 'widgets/toggle_row.dart';
import 'widgets/vault_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _vaultAddress = '—';
  bool _biometricEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final address = await StorageService().getKey(StorageKeys.vaultAddress);
    final biometric = await StorageService().getKey(
      StorageKeys.biometricEnabled,
    );
    if (!mounted) return;
    setState(() {
      _vaultAddress = address ?? 'Not initialised'; // TODO: real WDK address
      _biometricEnabled = biometric == 'true';
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    await StorageService().saveKey(
      StorageKeys.biometricEnabled,
      value ? 'true' : 'false',
    );
    if (!mounted) return;
    setState(() => _biometricEnabled = value);
  }

  Future<void> _confirmWipeVault() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => WipeDialog(),
    );
    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).wipeVault();
      if (mounted) context.go('/onboarding');
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).lock();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.darkBg,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: NeonColors.neonCyan),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(
                    child: VaultCard(address: _vaultAddress, ctx: context),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(label: 'ACTIVITY')),
                  SliverToBoxAdapter(
                    child: SettingsGroup(
                      children: [
                        _navRow(
                          icon: HugeIcons.strokeRoundedClock01,
                          label: 'Transaction history',
                          subtitle: 'All Sentinel executions',
                          color: NeonColors.neonCyan,
                          onTap: () => context.push('/profile/transaction'),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(label: 'SECURITY')),
                  SliverToBoxAdapter(
                    child: SettingsGroup(
                      children: [
                        ToggleRow(
                          icon: HugeIcons.strokeRoundedFingerPrint,
                          label: 'Biometric unlock',
                          subtitle: 'Face ID · Touch ID · Device PIN',
                          color: NeonColors.neonCyan,
                          value: _biometricEnabled,
                          onToggle: _toggleBiometric,
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(label: 'NETWORK')),
                  SliverToBoxAdapter(
                    child: SettingsGroup(
                      children: [
                        InfoRow(
                          icon: HugeIcons.strokeRoundedWifi01,
                          label: 'Active network',
                          value: 'Liquid',
                          color: NeonColors.neonCyan,
                        ),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedLinkCircle02,
                          label: 'Settlement asset',
                          value: 'USD₮ · XAU₮',
                          color: NeonColors.neonPurple,
                        ),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedAiBrain01,
                          label: 'Agent framework',
                          value: 'OpenClaw',
                          color: NeonColors.neonPink,
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(label: 'ABOUT')),
                  SliverToBoxAdapter(
                    child: SettingsGroup(
                      children: [
                        InfoRow(
                          icon: HugeIcons.strokeRoundedInformationCircle,
                          label: 'Version',
                          value: '1.0.0-hackathon',
                          color: NeonColors.textGrey,
                        ),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedSetting07,
                          label: 'Built with',
                          value: 'Flutter · WDK · Rust',
                          color: NeonColors.textGrey,
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(label: 'SESSION')),
                  SliverToBoxAdapter(
                    child: SettingsGroup(
                      children: [
                        _actionRow(
                          icon: HugeIcons.strokeRoundedLogout01,
                          label: 'Lock vault',
                          subtitle: 'Returns to login, keeps your keys',
                          color: NeonColors.neonPurple,
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _sectionLabel(label: 'DANGER ZONE'),
                  ),
                  SliverToBoxAdapter(
                    child: DangerSection(onWipe: _confirmWipeVault),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 48)),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Text(
            'IDENTITY',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 0.5, end: 1.0, duration: 1000.ms),
                const SizedBox(width: 6),
                const Text(
                  'SOVEREIGN',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel({required String label}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        label,
        style: const TextStyle(
          color: NeonColors.textGrey,
          fontSize: 10,
          letterSpacing: 2.5,
        ),
      ),
    );
  }

  Widget _navRow({
    required List<List<dynamic>> icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: NeonColors.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: NeonColors.textGrey.withValues(alpha: 0.4),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionRow({
    required List<List<dynamic>> icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: NeonColors.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
