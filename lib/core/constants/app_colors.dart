import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  // Light Theme Colors
  static const Color _lightBg = Color(0xFFF8F9FB);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE5E7EB);
  static const Color _lightPrimary = Color(0xFF111827);
  static const Color _lightSecondary = Color(0xFF6B7280);

  // Dark Theme Colors
  static const Color _darkBg = Color(0xFF0F172A); // Slate 900
  static const Color _darkCard = Color(0xFF1E293B); // Slate 800
  static const Color _darkBorder = Color(0xFF334155); // Slate 700
  static const Color _darkPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color _darkSecondary = Color(0xFF94A3B8); // Slate 400

  // Universal / Accent Colors
  static const Color accent = Color(0xFF00D2B6); // Brighter teal for both modes
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFB923C);
  
  // Dynamic Getters
  static Color get background => Get.isDarkMode ? _darkBg : _lightBg;
  static Color get card => Get.isDarkMode ? _darkCard : _lightCard;
  static Color get border => Get.isDarkMode ? _darkBorder : _lightBorder;
  static Color get primary => Get.isDarkMode ? _darkPrimary : _lightPrimary;
  static Color get secondary => Get.isDarkMode ? _darkSecondary : _lightSecondary;
  static Color get shadow => Get.isDarkMode ? Color(0x33000000) : Color(0x0D000000);
  static Color get divider => Get.isDarkMode ? _darkBorder : _lightBorder;
}
