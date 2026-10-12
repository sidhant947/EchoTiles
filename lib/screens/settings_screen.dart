import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../services/haptics.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final AppThemeData appTheme;
  final ValueChanged<AppThemeId> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.appTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _hapticEnabled;
  late AppThemeData _theme;

  @override
  void initState() {
    super.initState();
    _hapticEnabled = StorageService.getHapticEnabled();
    _theme = widget.appTheme;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appTheme != widget.appTheme) {
      _theme = widget.appTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
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
                'HAPTICS',
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
                  'Haptic Feedback',
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
                'THEME',
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
                          t.name,
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
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                Haptics.select();
                _showResetDialog(context, theme);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'RESET HIGH SCORES',
                style: TextStyle(
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

  void _showResetDialog(BuildContext context, AppThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: theme.dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Reset Scores?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: theme.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to reset all saved high scores and stars?',
            style: TextStyle(color: theme.textSecondary, fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'CANCEL',
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
              child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }
}
