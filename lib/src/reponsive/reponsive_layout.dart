import 'package:flutter/material.dart';

class ReponsiveLayout extends StatelessWidget {
  const ReponsiveLayout(
      {super.key,
      required this.moblie,
      required this.tablet,
      required this.desktop});
  final Widget moblie;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return moblie;
        } else if (constraints.maxWidth < 1100) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
