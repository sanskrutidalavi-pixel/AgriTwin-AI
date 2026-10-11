import 'package:flutter/material.dart';

/// Semantic and branding color palette for AgriTwin AI
class AppColors {
  AppColors._();

  // Primary agricultural green palette
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF002106);

  // Secondary & Accent tones
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryContainer = Color(0xFFC8E6C9);
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF052B09);

  static const Color tertiary = Color(0xFF00695C);
  static const Color tertiaryContainer = Color(0xFFE0F2F1);

  // Background & Surface
  static const Color background = Color(0xFFF6F8F5);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFEEF2EC);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1C1A);
  static const Color textSecondary = Color(0xFF555D54);
  static const Color textTertiary = Color(0xFF8A9388);

  // Borders & Dividers
  static const Color border = Color(0xFFE0E5DF);
  static const Color divider = Color(0xFFEBEFEA);

  // Semantic Status / Risk Indicators
  // Positive / Low Risk
  static const Color positive = Color(0xFF2E7D32);
  static const Color positiveLight = Color(0xFFE8F5E9);
  static const Color onPositive = Color(0xFF1B5E20);

  // Warning / Medium Risk
  static const Color warning = Color(0xFFE65100);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color onWarning = Color(0xFFBF360C);

  // Urgent / High Risk
  static const Color urgent = Color(0xFFD32F2F);
  static const Color urgentLight = Color(0xFFFFEBEE);
  static const Color onUrgent = Color(0xFFB71C1C);

  // Neutral / Info
  static const Color info = Color(0xFF0277BD);
  static const Color infoLight = Color(0xFFE1F5FE);
  static const Color onInfo = Color(0xFF01579B);
}
