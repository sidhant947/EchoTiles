import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import '../services/haptics.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final AppThemeData appTheme;
  final ValueChanged<AppThemeId> onThemeChanged;
  final ValueChanged<Locale?> onLocaleChanged;

  const SettingsScreen({
    super.key,
    required this.appTheme,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _hapticEnabled;
  late AppThemeData _theme;
  late String? _localeCode;

  @override
  void initState() {
    super.initState();
    _hapticEnabled = StorageService.getHapticEnabled();
    _theme = widget.appTheme;
    _localeCode = StorageService.getLocaleCode();
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appTheme != widget.appTheme) {
      _theme = widget.appTheme;
    }
  }

  String _themeName(AppThemeId id, AppLocalizations l10n) {
    switch (id) {
      case AppThemeId.clean:
        return l10n.themeNameClean;
      case AppThemeId.dark:
        return l10n.themeNameDark;
      case AppThemeId.amoled:
        return l10n.themeNameAmoled;
      case AppThemeId.forest:
        return l10n.themeNameForest;
      case AppThemeId.ocean:
        return l10n.themeNameOcean;
      case AppThemeId.sunset:
        return l10n.themeNameSunset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.appBarFg,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l10n.hapticsSection,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.textMuted,
                ),
              ),
            ),
            Material(
              color: theme.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.border, width: 1.8),
              ),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: Text(
                  l10n.hapticFeedback,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: theme.textPrimary,
                  ),
                ),
                value: _hapticEnabled,
                activeThumbColor: theme.switchActiveColor,
                onChanged: (val) {
                  setState(() => _hapticEnabled = val);
                  StorageService.setHapticEnabled(val);
                },
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l10n.themeSection,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.textMuted,
                ),
              ),
            ),
            Material(
              color: theme.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.border, width: 1.8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: AppThemes.all.map((t) {
                  final isSelected = t.id == theme.id;
                  final isLast = t.id == AppThemes.all.last.id;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        title: Text(
                          _themeName(t.id, l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: theme.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: theme.switchActiveColor, size: 24)
                            : null,
                        onTap: () {
                          Haptics.select();
                          StorageService.setThemeId(t.id.name);
                          setState(() {
                            _theme = t;
                          });
                          widget.onThemeChanged(t.id);
                        },
                      ),
                      if (!isLast)
                        Divider(height: 1, indent: 20, endIndent: 20, color: theme.border.withValues(alpha: 0.3)),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l10n.languageSection,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.textMuted,
                ),
              ),
            ),
            Material(
              color: theme.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.border, width: 1.8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildLanguageTile(
                    theme: theme,
                    title: l10n.systemDefault,
                    localeCode: null,
                  ),
                  Divider(height: 1, indent: 20, endIndent: 20, color: theme.border.withValues(alpha: 0.3)),
                  _buildLanguageTile(
                    theme: theme,
                    title: l10n.langEnglish,
                    localeCode: 'en',
                  ),
                  Divider(height: 1, indent: 20, endIndent: 20, color: theme.border.withValues(alpha: 0.3)),
                  _buildLanguageTile(
                    theme: theme,
                    title: l10n.langItalian,
                    localeCode: 'it',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                Haptics.select();
                _showResetDialog(context, theme, l10n);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                l10n.resetHighScores,
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required AppThemeData theme,
    required String title,
    required String? localeCode,
  }) {
    final isSelected = _localeCode == localeCode;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: theme.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: theme.switchActiveColor, size: 24)
          : null,
      onTap: () {
        Haptics.select();
        setState(() {
          _localeCode = localeCode;
        });
        StorageService.setLocaleCode(localeCode);
        widget.onLocaleChanged(localeCode == null ? null : Locale(localeCode));
      },
    );
  }

  void _showResetDialog(BuildContext context, AppThemeData theme, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: theme.dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            l10n.resetScoresTitle,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: theme.textPrimary,
            ),
          ),
          content: Text(
            l10n.resetScoresMessage,
            style: TextStyle(color: theme.textSecondary, fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: theme.textMuted, fontWeight: FontWeight.w800),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await StorageService.resetHighScores();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.reset, style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }
}
