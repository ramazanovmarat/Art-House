import 'package:flutter/material.dart';

class BackgroundApp extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  const BackgroundApp({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(child: child),
        ],
      ),
    );
  }
}
