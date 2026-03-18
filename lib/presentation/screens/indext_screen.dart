/*
* Created by Connel Asikong on 13/03/2026
*
*/

import 'package:defai/utils/defai_themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IndexScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const IndexScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        selectedItemColor: NeonColors.neonCyan,
        unselectedItemColor: NeonColors.textGrey,
        backgroundColor: NeonColors.darkBg,
        selectedLabelStyle: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(inherit: true),
        unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          inherit: true,
          fontWeight: FontWeight.w600,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hub_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Skills',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Identity'),
        ],
      ),
    );
  }
}
