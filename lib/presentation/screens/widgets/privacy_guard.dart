/*
* Created by Connel Asikong on 10/03/2026
*
*/

import 'dart:ui';

import 'package:flutter/material.dart';

class PrivacyGuard extends StatefulWidget {
  final Widget child;

  const PrivacyGuard({super.key, required this.child});

  @override
  State<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends State<PrivacyGuard>
    with WidgetsBindingObserver {
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      // Blur when app is inactive (swiping) or paused (background)
      _isBlurred = state != AppLifecycleState.resumed;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBlurred)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Icon(
                    Icons.security,
                    color: Theme.of(context).primaryColor,
                    size: 100,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
