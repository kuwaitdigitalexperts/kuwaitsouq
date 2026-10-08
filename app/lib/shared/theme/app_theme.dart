import 'package:flutter/material.dart';

class AppTheme {
  // KuwaitSouq Brand Colors matching Screenshots
  static const Color primaryBlue = Color(0xFF2563EB); // Royal Blue top bar & primary CTA
  static const Color primaryDarkBlue = Color(0xFF1D4ED8);
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color brandOrange = Color(0xFFF97316); // Boost badge & Story orange
  static const Color priceRed = Color(0xFFE11D48); // Bold red price from screenshot
  static const Color whatsAppGreen = Color(0xFF25D366); // WhatsApp CTA
  static const Color callBtn = Color(0xFF2563EB); // Call phone button
  static const Color whatsAppBtn = Color(0xFF25D366);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryLightGreen = Color(0xFF34D399);
  static const Color accentOrange = Color(0xFFF97316);

  static const Color bgLight = Color(0xFFF8FAFC); // Clean background
  static const Color surfaceWhite = Colors.white; // Pure white cards
  static const Color inputBg = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF0F172A); // Slate 900
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color cardShadow = Color(0x08000000);
  static const Color scaffoldBg = bgLight;

  // Category Pastel Colors
  static const Color pastelBlue = Color(0xFFEFF6FF);
  static const Color pastelGreen = Color(0xFFECFDF5);
  static const Color pastelPeach = Color(0xFFFFF7ED);
  static const Color pastelPurple = Color(0xFFFAF5FF);
  static const Color pastelSky = Color(0xFFF0F9FF);
  static const Color pastelAmber = Color(0xFFFEFCE8);
  static const Color pastelRose = Color(0xFFFFF1F2);

  // Backward compatibility aliases
  static const Color tagBg = Color(0xFFF1F5F9);
  static const Color textLight = Color(0xFF0F172A);
  static const Color bgDark = Color(0xFFF8FAFC);
  static const Color surfaceDark = Colors.white;
  static const Color borderDark = Color(0xFFE2E8F0);
  static const Color headerGreen = Color(0xFF2563EB);
  static const Color inputDark = Color(0xFFF1F5F9);
  static const Color cardDark = Colors.white;

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      surface: surfaceWhite,
      onSurface: textDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
