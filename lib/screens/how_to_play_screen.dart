import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import '../services/haptics.dart';

class HowToPlayScreen extends StatelessWidget {
  final AppThemeData appTheme;

  const HowToPlayScreen({
    super.key,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.textPrimary, size: 22),
          onPressed: () {
            Haptics.select();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          l10n.howToPlayTitle,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _buildCard(
              theme: theme,
              title: l10n.singleTapTitle,
              subtitle: l10n.singleTapSubtitle,
              visual: _SingleTileVisual(theme: theme),
              points: [
                l10n.singleTapPoint1,
                l10n.singleTapPoint2,
                l10n.singleTapPoint3,
              ],
            ),
            const SizedBox(height: 18),
            _buildCard(
              theme: theme,
              title: l10n.holdTilesTitle,
              subtitle: l10n.holdTilesSubtitle,
              visual: _HoldTileVisual(theme: theme),
              points: [
                l10n.holdTilesPoint1,
                l10n.holdTilesPoint2,
                l10n.holdTilesPoint3,
              ],
            ),
            const SizedBox(height: 18),
            _buildCard(
              theme: theme,
              title: l10n.avoidMistakesTitle,
              subtitle: l10n.avoidMistakesSubtitle,
              visual: _MistakeVisual(theme: theme),
              points: [
                l10n.avoidMistakesPoint1,
                l10n.avoidMistakesPoint2,
                l10n.avoidMistakesPoint3,
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Haptics.select();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.playBg,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context).gotItLetsPlay,
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required AppThemeData theme,
    required String title,
    required String subtitle,
    required Widget visual,
    required List<String> points,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.border, width: 1.5),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          visual,
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.playBg,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: theme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleTileVisual extends StatelessWidget {
  final AppThemeData theme;

  const _SingleTileVisual({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.6), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: i < 3
                            ? BorderSide(color: theme.border.withValues(alpha: 0.35), width: 1.0)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: Container(
                height: 2,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: Center(
                child: Text(
                  AppLocalizations.of(context).judgmentLine,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 2,
              bottom: 24,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: 76,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.tileColor,
                        border: Border.all(color: theme.tileBorder, width: 2.0),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.playBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            AppLocalizations.of(context).tap,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 20,
              bottom: 6,
              child: Icon(
                Icons.touch_app_rounded,
                color: theme.playBg,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldTileVisual extends StatelessWidget {
  final AppThemeData theme;

  const _HoldTileVisual({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.6), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: i < 3
                            ? BorderSide(color: theme.border.withValues(alpha: 0.35), width: 1.0)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 26,
              child: Container(
                height: 2,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            Positioned(
              left: 80,
              bottom: 20,
              child: SizedBox(
                width: 76,
                height: 120,
                child: CustomPaint(
                  painter: _HoldTilePreviewPainter(theme: theme),
                ),
              ),
            ),
            Positioned(
              left: 105,
              bottom: 2,
              child: Icon(
                Icons.touch_app_rounded,
                color: theme.playBg,
                size: 26,
              ),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.playBg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.playBg.withValues(alpha: 0.4), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 14, color: theme.playBg),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context).chargingCombo,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: theme.playBg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldTilePreviewPainter extends CustomPainter {
  final AppThemeData theme;

  const _HoldTilePreviewPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final tailPaint = Paint()..color = theme.tileTailColor.withValues(alpha: 0.70);
    canvas.drawRect(rect, tailPaint);

    final progressHeight = size.height * 0.48;
    final filledRect = Rect.fromLTWH(
      0,
      size.height - progressHeight,
      size.width,
      progressHeight,
    );
    final hitFillPaint = Paint()..color = theme.tileHitColor.withValues(alpha: 0.85);
    canvas.drawRect(filledRect, hitFillPaint);

    final contactY = size.height - progressHeight;
    final sparkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(2, contactY), Offset(size.width - 2, contactY), sparkPaint);

    final borderPaint = Paint()
      ..color = theme.tileHitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(rect, borderPaint);

    final centerX = size.width / 2;
    final circleRadius = min(15.0, (size.width - 14) / 2);
    final circleCenter = Offset(centerX, size.height - circleRadius - 6);
    final lineTop = 8.0;
    final lineBottom = circleCenter.dy - circleRadius;

    if (lineBottom > lineTop) {
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.95)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(centerX, lineTop), Offset(centerX, lineBottom), linePaint);
      canvas.drawCircle(Offset(centerX, lineTop), 3.5, linePaint);
    }

    final circlePaint = Paint()
      ..color = theme.tileHitColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    final circleBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(circleCenter, circleRadius, circleBorder);

    final innerDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius * 0.45, innerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MistakeVisual extends StatelessWidget {
  final AppThemeData theme;

  const _MistakeVisual({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.35), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).missTriggerTitle,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context).missTriggerText,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
