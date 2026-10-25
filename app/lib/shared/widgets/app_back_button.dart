import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onBack;
  final String fallbackRoute;

  const AppBackButton({
    super.key,
    this.color,
    this.onBack,
    this.fallbackRoute = '/',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: color ?? const Color(0xFF0F172A),
        size: 20,
      ),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onBack != null) {
          onBack!();
          return;
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go(fallbackRoute);
        }
      },
    );
  }
}
