/*
* Created by Connel Asikong on 13/03/2026
*
*/

import 'package:defai/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeedBackupScreen extends ConsumerWidget {
  const SeedBackupScreen({super.key, required this.mnemonic});
  final String mnemonic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final words = mnemonic.split(' ');

    return Scaffold(
      appBar: AppBar(title: const Text("Backup Vault")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Write down these 12 words",
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: 12,
              itemBuilder: (context, i) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${i + 1}. ${words[i]}",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => context.push('/seed-verify', extra: mnemonic),
                // onPressed: () => context.push('/seed-verify', extra: words),
                child: const Text("I'VE WRITTEN IT DOWN"),
              ),
            ),
            SizedBox(height: phoneHeight * .02),
          ],
        ),
      ),
    );
  }
}
