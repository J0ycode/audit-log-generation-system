import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Slate-based palette. Status colours are dark enough for 4.5:1 text contrast
/// on white and on their own 10% tint.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF1F5F9);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF8FAFC);
  static const border = Color(0xFFE2E8F0);
  static const text = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);
  static const primary = Color(0xFF1E293B);

  static const sidebar = Color(0xFF0F172A);
  static const sidebarActive = Color(0xFF1E293B);
  static const sidebarText = Color(0xFFE2E8F0);
  static const sidebarMuted = Color(0xFF94A3B8);
  static const accent = Color(0xFF22C55E);

  static const info = Color(0xFF1D4ED8);
  static const insert = Color(0xFF15803D);
  static const update = Color(0xFFB45309);
  static const delete = Color(0xFFB91C1C);
}

/// Colour, icon and label for each audit action, so meaning never relies on colour alone.
class ActionStyle {
  final Color color;
  final IconData icon;
  final String label;

  const ActionStyle(this.color, this.icon, this.label);

  static const _styles = {
    'INSERT': ActionStyle(AppColors.insert, Icons.add_circle_outline, 'Insert'),
    'UPDATE': ActionStyle(AppColors.update, Icons.edit_outlined, 'Update'),
    'DELETE': ActionStyle(AppColors.delete, Icons.delete_outline, 'Delete'),
  };

  static ActionStyle of(String action) =>
      _styles[action] ?? const ActionStyle(AppColors.textMuted, Icons.help_outline, 'Unknown');
}

const tabularFigures = TextStyle(fontFeatures: [FontFeature.tabularFigures()]);

String tableLabel(String table) =>
    table.isEmpty ? table : table[0].toUpperCase() + table.substring(1);

class AppTheme {
  AppTheme._();

  static ThemeData light({bool useGoogleFonts = true}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.delete,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
    );
    final textTheme = (useGoogleFonts ? GoogleFonts.firaSansTextTheme(base.textTheme) : base.textTheme)
        .apply(bodyColor: AppColors.text, displayColor: AppColors.text);
    final buttonText = textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);
    final radius = BorderRadius.circular(8);
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: color, width: width));

    return base.copyWith(
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          foregroundColor: AppColors.text,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 44),
          foregroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonText,
        ),
      ),
      tooltipTheme: const TooltipThemeData(waitDuration: Duration(milliseconds: 400)),
    );
  }
}
