import 'package:flutter/material.dart';

enum AppThemeId { clean, dark, amoled, forest, ocean, sunset }

class AppThemeData {
  final AppThemeId id;
  final String name;
  final String emoji;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color appBarBg;
  final Color appBarFg;
  final Color playBg;
  final Color playBorder;
  final Color playShadow;
  final Color songsBg;
  final Color songsBorder;
  final Color songsShadow;
  final Color settingsBg;
  final Color settingsBorder;
  final Color settingsShadow;
  final Color tileColor;
  final Color tileBorder;
  final Color tileHitColor;
  final Color tileTailColor;
  final Color cardBg;
  final Color dialogBg;
  final Color switchActiveColor;

  const AppThemeData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.appBarBg,
    required this.appBarFg,
    required this.playBg,
    required this.playBorder,
    required this.playShadow,
    required this.songsBg,
    required this.songsBorder,
    required this.songsShadow,
    required this.settingsBg,
    required this.settingsBorder,
    required this.settingsShadow,
    required this.tileColor,
    required this.tileBorder,
    required this.tileHitColor,
    required this.tileTailColor,
    required this.cardBg,
    required this.dialogBg,
    required this.switchActiveColor,
  });

  ThemeData toMaterialTheme() {
    final isDark = background.computeLuminance() < 0.3;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Fredoka',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: playBg,
        onPrimary: Colors.white,
        secondary: songsBg,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: const Color(0xFFEF4444),
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: appBarFg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: appBarFg,
          fontFamily: 'Fredoka',
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(color: cardBg),
    );
  }
}

class AppThemes {
  static const clean = AppThemeData(
    id: AppThemeId.clean,
    name: 'Clean',
    emoji: '⬜',
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE2E8F0),
    border: Color(0xFF94A3B8),
    borderStrong: Color(0xFF64748B),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    appBarBg: Color(0xFFF8FAFC),
    appBarFg: Color(0xFF0F172A),
    playBg: Color(0xFF10B981),
    playBorder: Color(0xFF047857),
    playShadow: Color(0xFF047857),
    songsBg: Color(0xFF3897F0),
    songsBorder: Color(0xFF1E6BB8),
    songsShadow: Color(0xFF1E6BB8),
    settingsBg: Color(0xFF8B5CF6),
    settingsBorder: Color(0xFF6D28D9),
    settingsShadow: Color(0xFF6D28D9),
    tileColor: Color(0xFF1E293B),
    tileBorder: Color(0xFF0F172A),
    tileHitColor: Color(0xFF10B981),
    tileTailColor: Color(0xFF334155),
    cardBg: Color(0xFFFFFFFF),
    dialogBg: Color(0xFFFFFFFF),
    switchActiveColor: Color(0xFF10B981),
  );

  static const dark = AppThemeData(
    id: AppThemeId.dark,
    name: 'Dark',
    emoji: '🌑',
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF334155),
    border: Color(0xFF475569),
    borderStrong: Color(0xFF64748B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    appBarBg: Color(0xFF1E293B),
    appBarFg: Color(0xFFF1F5F9),
    playBg: Color(0xFF10B981),
    playBorder: Color(0xFF047857),
    playShadow: Color(0xFF064E3B),
    songsBg: Color(0xFF3B82F6),
    songsBorder: Color(0xFF1D4ED8),
    songsShadow: Color(0xFF1E3A8A),
    settingsBg: Color(0xFF8B5CF6),
    settingsBorder: Color(0xFF6D28D9),
    settingsShadow: Color(0xFF4C1D95),
    tileColor: Color(0xFF38BDF8),
    tileBorder: Color(0xFF0284C7),
    tileHitColor: Color(0xFF34D399),
    tileTailColor: Color(0xFF0369A1),
    cardBg: Color(0xFF1E293B),
    dialogBg: Color(0xFF1E293B),
    switchActiveColor: Color(0xFF10B981),
  );

  static const amoled = AppThemeData(
    id: AppThemeId.amoled,
    name: 'AMOLED Dark',
    emoji: '🖤',
    background: Color(0xFF000000),
    surface: Color(0xFF0A0A0A),
    surfaceVariant: Color(0xFF171717),
    border: Color(0xFF27272A),
    borderStrong: Color(0xFF3F3F46),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA1A1AA),
    textMuted: Color(0xFF71717A),
    appBarBg: Color(0xFF000000),
    appBarFg: Color(0xFFFFFFFF),
    playBg: Color(0xFF10B981),
    playBorder: Color(0xFF059669),
    playShadow: Color(0xFF047857),
    songsBg: Color(0xFF3B82F6),
    songsBorder: Color(0xFF2563EB),
    songsShadow: Color(0xFF1D4ED8),
    settingsBg: Color(0xFFA855F7),
    settingsBorder: Color(0xFF9333EA),
    settingsShadow: Color(0xFF7E22CE),
    tileColor: Color(0xFF2563EB),
    tileBorder: Color(0xFF1D4ED8),
    tileHitColor: Color(0xFF10B981),
    tileTailColor: Color(0xFF1E3A8A),
    cardBg: Color(0xFF0A0A0A),
    dialogBg: Color(0xFF0A0A0A),
    switchActiveColor: Color(0xFF10B981),
  );

  static const forest = AppThemeData(
    id: AppThemeId.forest,
    name: 'Forest',
    emoji: '🌿',
    background: Color(0xFF1A2E1A),
    surface: Color(0xFF243324),
    surfaceVariant: Color(0xFF2F4A2F),
    border: Color(0xFF4A6741),
    borderStrong: Color(0xFF5A7A50),
    textPrimary: Color(0xFFE8F5E9),
    textSecondary: Color(0xFFC8E6C9),
    textMuted: Color(0xFF81C784),
    appBarBg: Color(0xFF243324),
    appBarFg: Color(0xFFE8F5E9),
    playBg: Color(0xFF43A047),
    playBorder: Color(0xFF2E7D32),
    playShadow: Color(0xFF1B5E20),
    songsBg: Color(0xFF26A69A),
    songsBorder: Color(0xFF00796B),
    songsShadow: Color(0xFF004D40),
    settingsBg: Color(0xFF8D6E63),
    settingsBorder: Color(0xFF5D4037),
    settingsShadow: Color(0xFF3E2723),
    tileColor: Color(0xFF66BB6A),
    tileBorder: Color(0xFF2E7D32),
    tileHitColor: Color(0xFFA5D6A7),
    tileTailColor: Color(0xFF388E3C),
    cardBg: Color(0xFF243324),
    dialogBg: Color(0xFF243324),
    switchActiveColor: Color(0xFF43A047),
  );

  static const ocean = AppThemeData(
    id: AppThemeId.ocean,
    name: 'Ocean',
    emoji: '🌊',
    background: Color(0xFF0D1B2A),
    surface: Color(0xFF1B2D3F),
    surfaceVariant: Color(0xFF243B52),
    border: Color(0xFF2E5F7A),
    borderStrong: Color(0xFF3A7A9C),
    textPrimary: Color(0xFFE0F2FE),
    textSecondary: Color(0xFFBAE6FD),
    textMuted: Color(0xFF7DD3FC),
    appBarBg: Color(0xFF1B2D3F),
    appBarFg: Color(0xFFE0F2FE),
    playBg: Color(0xFF0EA5E9),
    playBorder: Color(0xFF0369A1),
    playShadow: Color(0xFF0C4A6E),
    songsBg: Color(0xFF6366F1),
    songsBorder: Color(0xFF4338CA),
    songsShadow: Color(0xFF312E81),
    settingsBg: Color(0xFF8B5CF6),
    settingsBorder: Color(0xFF6D28D9),
    settingsShadow: Color(0xFF4C1D95),
    tileColor: Color(0xFF38BDF8),
    tileBorder: Color(0xFF0284C7),
    tileHitColor: Color(0xFF38BDF8),
    tileTailColor: Color(0xFF075985),
    cardBg: Color(0xFF1B2D3F),
    dialogBg: Color(0xFF1B2D3F),
    switchActiveColor: Color(0xFF0EA5E9),
  );

  static const sunset = AppThemeData(
    id: AppThemeId.sunset,
    name: 'Sunset',
    emoji: '🌅',
    background: Color(0xFF1C0A00),
    surface: Color(0xFF2D1200),
    surfaceVariant: Color(0xFF3D1F00),
    border: Color(0xFF7C3A10),
    borderStrong: Color(0xFF9C4A18),
    textPrimary: Color(0xFFFFF3E0),
    textSecondary: Color(0xFFFFCCBC),
    textMuted: Color(0xFFFFAB91),
    appBarBg: Color(0xFF2D1200),
    appBarFg: Color(0xFFFFF3E0),
    playBg: Color(0xFFFF6B35),
    playBorder: Color(0xFFBF360C),
    playShadow: Color(0xFF870000),
    songsBg: Color(0xFFE91E63),
    songsBorder: Color(0xFF880E4F),
    songsShadow: Color(0xFF560027),
    settingsBg: Color(0xFF9C27B0),
    settingsBorder: Color(0xFF4A148C),
    settingsShadow: Color(0xFF12005E),
    tileColor: Color(0xFFFF7043),
    tileBorder: Color(0xFFBF360C),
    tileHitColor: Color(0xFFFFAB91),
    tileTailColor: Color(0xFFD84315),
    cardBg: Color(0xFF2D1200),
    dialogBg: Color(0xFF2D1200),
    switchActiveColor: Color(0xFFFF6B35),
  );

  static const all = [amoled, clean, dark, forest, ocean, sunset];

  static AppThemeData fromId(AppThemeId id) {
    return all.firstWhere((t) => t.id == id, orElse: () => amoled);
  }

  static AppThemeData fromName(String name) {
    return all.firstWhere((t) => t.id.name == name, orElse: () => amoled);
  }
}
