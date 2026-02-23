import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const primary = Color(0xFF1A73E8);
  static const primaryLight = Color(0xFF4DA3FF);
  static const primaryDark = Color(0xFF0D47A1);

  // Secondary
  static const secondary = Color(0xFF03DAC6);
  static const secondaryLight = Color(0xFF66FFF9);
  static const secondaryDark = Color(0xFF00A896);

  // Neutral
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const backgroundDark = Color(0xFF121212);

  // Text
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textPrimaryDark = Color(0xFFE0E0E0);
  static const textSecondaryDark = Color(0xFF9E9E9E);

  // Status
  static const error = Color(0xFFB00020);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
}
