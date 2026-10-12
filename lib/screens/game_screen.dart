import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/app_theme.dart';
import '../models/game_models.dart';
import '../services/audio_service.dart';
import '../services/haptics.dart';
import '../services/storage_service.dart';

class GameScreen extends StatefulWidget {
  final SongItem song;
  final AppThemeData appTheme;

  const GameScreen({
    super.key,
    required this.song,
    required this.appTheme,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  static const double _targetLineFactor = 0.80;
  static const double _tileHeightFactor = 0.20;
  static const double _beatGap = 0.06;

  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  GameStatus _status = GameStatus.ready;
  final List<GameTile> _tiles = [];
  final List<HitFeedback> _feedbacks = [];
  final Map<int, int> _activePointerTiles = {};
  final List<int> _lanePatternQueue = [];
  final List<double> _gapPatternQueue = [];

  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _nextTileIndex = 0;
  int _lastLane = -1;
  int _failedLane = -1;
  int _totalNotes = 160;

  double _baseScrollSpeed = 0.50;
  double _songProgress = 0.0;
  final Random _rng = Random();

  Duration? _audioDuration;
  bool _songAudioFinished = false;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<void>? _completeSub;
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _totalNotes = widget.song.notesCount;
    _initLevel();
    _ticker = createTicker(_onTick);
    _listenAudio();
  }

  void _listenAudio() {
    _durationSub = AudioService.instance.onDurationChanged.listen((dur) {
      if (dur.inMilliseconds > 0 && mounted) {
        setState(() {
          _audioDuration = dur;
          final calcNotes = (dur.inMilliseconds / 1000.0 * ((widget.song.bpm / 120.0) * 2.3)).round();
          if (calcNotes > _totalNotes) {
            _totalNotes = calcNotes;
          }
        });
      }
    });

    _positionSub = AudioService.instance.onPositionChanged.listen((pos) {
      if (_audioDuration != null && _audioDuration!.inMilliseconds > 0 && mounted) {
        setState(() {
          _songProgress = (pos.inMilliseconds / _audioDuration!.inMilliseconds).clamp(0.0, 1.0);
        });
      }
    });

    _completeSub = AudioService.instance.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _songAudioFinished = true;
          _songProgress = 1.0;
        });
      }
    });
  }

  void _initLevel() {
    _status = GameStatus.ready;
    _score = 0;
    _combo = 0;
    _maxCombo = 0;
    _nextTileIndex = 0;
    _lastLane = -1;
    _failedLane = -1;
    _songAudioFinished = false;
    _totalNotes = widget.song.notesCount;
    if (_audioDuration != null && _audioDuration!.inMilliseconds > 0) {
      final calcNotes = (_audioDuration!.inMilliseconds / 1000.0 * ((widget.song.bpm / 120.0) * 2.3)).round();
      if (calcNotes > _totalNotes) {
        _totalNotes = calcNotes;
      }
    }
    _tiles.clear();
    _feedbacks.clear();
    _activePointerTiles.clear();
    _lanePatternQueue.clear();
    _gapPatternQueue.clear();
    _baseScrollSpeed = (widget.song.bpm / 120.0) * 0.50;
    _songProgress = 0.0;

    _spawnTile(initialY: _targetLineFactor);
    for (int i = 0; i < 4; i++) {
      _spawnTile();
    }
  }

  int _generateNextLane() {
    if (_lanePatternQueue.isEmpty) {
      _fillLanePatterns();
    }
    int lane = _lanePatternQueue.removeAt(0);
    if (lane == _lastLane) {
      lane = (_lastLane + 1 + _rng.nextInt(3)) % 4;
    }
    _lastLane = lane;
    return lane;
  }

  void _fillLanePatterns() {
    final patternType = _rng.nextInt(6);
    switch (patternType) {
      case 0:
        final s = _rng.nextInt(4);
        _lanePatternQueue.addAll([s, (s + 1) % 4, (s + 2) % 4, (s + 3) % 4]);
        _gapPatternQueue.addAll([0.05, 0.05, 0.05, 0.07]);
        break;
      case 1:
        final s = _rng.nextInt(4);
        _lanePatternQueue.addAll([s, (s + 3) % 4, (s + 2) % 4, (s + 1) % 4]);
        _gapPatternQueue.addAll([0.05, 0.05, 0.05, 0.07]);
        break;
      case 2:
        final a = _rng.nextInt(4);
        final b = (a + 1 + _rng.nextInt(3)) % 4;
        _lanePatternQueue.addAll([a, b, a, b]);
        _gapPatternQueue.addAll([0.06, 0.06, 0.06, 0.08]);
        break;
      case 3:
        final a = _rng.nextInt(4);
        final b = (a + 2) % 4;
        final c = (a + 1) % 4;
        final d = (a + 3) % 4;
        _lanePatternQueue.addAll([a, b, c, d]);
        _gapPatternQueue.addAll([0.05, 0.06, 0.05, 0.07]);
        break;
      case 4:
        final a = _rng.nextInt(4);
        final b = (a + 1 + _rng.nextInt(3)) % 4;
        final c = (b + 1 + _rng.nextInt(3)) % 4;
        _lanePatternQueue.addAll([a, b, c, b]);
        _gapPatternQueue.addAll([0.06, 0.06, 0.06, 0.07]);
        break;
      default:
        int current = _lastLane == -1 ? _rng.nextInt(4) : _lastLane;
        for (int i = 0; i < 4; i++) {
          current = (current + 1 + _rng.nextInt(3)) % 4;
          _lanePatternQueue.add(current);
          _gapPatternQueue.add(0.06);
        }
        break;
    }
  }

  void _spawnTile({double? initialY}) {
    if (_songAudioFinished || _nextTileIndex >= _totalNotes) return;

    final lane = _generateNextLane();
    final double gap = _gapPatternQueue.isNotEmpty
        ? _gapPatternQueue.removeAt(0)
        : _beatGap;

    final allowLong = _nextTileIndex >= 10 && _songProgress < 0.85;
    final isLong = initialY == null && allowLong && (_rng.nextDouble() < 0.14);
    final length = isLong ? 3.0 : 1.0;

    double yPos;
    if (initialY != null) {
      yPos = initialY;
    } else {
      if (_tiles.isNotEmpty) {
        final highestTop = _tiles
            .map((t) => t.y - (_tileHeightFactor * t.length))
            .reduce(min);
        yPos = highestTop - gap;
      } else {
        yPos = _targetLineFactor;
      }
    }

    _tiles.add(
      GameTile(
        id: _nextTileIndex,
        lane: lane,
        y: yPos,
        length: length,
        isLong: isLong,
        noteIndex: _nextTileIndex,
      ),
    );
    _nextTileIndex++;
  }

  void _onTick(Duration elapsed) {
    if (_status != GameStatus.playing) {
      _lastElapsed = elapsed;
      return;
    }

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.1) return;

    final progressFactor = _songProgress * 0.55;
    final comboFactor = min(0.35, (_combo / 50.0) * 0.1);
    final currentSpeed = _baseScrollSpeed * (1.0 + progressFactor + comboFactor);

    setState(() {
      for (final tile in _tiles) {
        tile.y += currentSpeed * dt;
        if (tile.isHolding && tile.isLong) {
          final tileHeight = _tileHeightFactor * tile.length;
          final prevStep = (tile.holdProgress * 10).floor();
          tile.holdProgress = (tile.holdProgress + (currentSpeed * dt) / tileHeight).clamp(0.0, 1.0);
          _score += (dt * 220).toInt();

          final currStep = (tile.holdProgress * 10).floor();
          if (currStep > prevStep) {
            _combo++;
            if (_combo > _maxCombo) _maxCombo = _combo;
            Haptics.light();
          }

          if (tile.holdProgress >= 1.0) {
            tile.isHolding = false;
            tile.isHit = true;
            _score += 150;
            _combo += 2;
            if (_combo > _maxCombo) _maxCombo = _combo;
            Haptics.medium();
            final sw = _screenSize.width > 0 ? _screenSize.width : 400.0;
            final sh = _screenSize.height > 0 ? _screenSize.height : 800.0;
            _feedbacks.add(
              HitFeedback(
                text: 'PERFECT!',
                quality: HitQuality.perfect,
                x: (tile.lane + 0.5) * (sw / 4),
                y: sh * _targetLineFactor,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          }
        }
      }

      final highestTop = _tiles.isEmpty
          ? 1.0
          : _tiles.map((t) => t.y - (_tileHeightFactor * t.length)).reduce(min);
      if (highestTop > -0.30 && !_songAudioFinished && _nextTileIndex < _totalNotes) {
        _spawnTile();
      }

      for (final tile in _tiles) {
        if (!tile.isHit && !tile.isHolding && !tile.isMissed && tile.y > 1.02) {
          tile.isMissed = true;
          _triggerGameOver(tile.lane);
          return;
        }
      }

      _tiles.removeWhere((t) => (t.isHit && !t.isHolding && t.y > 1.30));

      final now = DateTime.now().millisecondsSinceEpoch;
      _feedbacks.removeWhere((f) => now - f.timestamp > 700);

      if (_audioDuration == null || _audioDuration!.inMilliseconds == 0) {
        _songProgress = (_nextTileIndex / _totalNotes).clamp(0.0, 1.0);
      }

      if ((_songAudioFinished || _nextTileIndex >= _totalNotes) && _tiles.every((t) => t.isHit)) {
        _triggerVictory();
      }
    });
  }

  void _startGame() async {
    _status = GameStatus.playing;
    _lastElapsed = Duration.zero;
    _ticker.start();
    if (widget.song.assetAudio.isNotEmpty) {
      await AudioService.instance.playSong(widget.song.assetAudio);
      final dur = await AudioService.instance.getDuration();
      if (dur != null && dur.inMilliseconds > 0 && mounted) {
        setState(() {
          _audioDuration = dur;
          final calcNotes = (dur.inMilliseconds / 1000.0 * ((widget.song.bpm / 120.0) * 2.3)).round();
          if (calcNotes > _totalNotes) {
            _totalNotes = calcNotes;
          }
        });
      }
    }
  }

  void _pauseGame() {
    if (_status != GameStatus.playing && _status != GameStatus.ready) return;
    setState(() => _status = GameStatus.paused);
    if (_ticker.isActive) {
      _ticker.stop();
    }
    AudioService.instance.pauseSong();
  }

  void _resumeGame() {
    if (_status != GameStatus.paused) return;
    setState(() => _status = GameStatus.playing);
    _lastElapsed = Duration.zero;
    _ticker.start();
    AudioService.instance.resumeSong();
  }

  void _triggerGameOver(int lane, [Offset? mistapOffset]) {
    _status = GameStatus.gameOver;
    _failedLane = lane;
    _ticker.stop();
    AudioService.instance.stopSong();
    Haptics.heavy();
    if (mistapOffset != null) {
      _feedbacks.add(
        HitFeedback(
          text: 'MISS!',
          quality: HitQuality.miss,
          x: mistapOffset.dx,
          y: mistapOffset.dy,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    StorageService.setHighScore(widget.song.id, _score);
    StorageService.setBestCombo(_maxCombo);
    setState(() {});
  }

  void _triggerVictory() {
    _status = GameStatus.victory;
    _ticker.stop();
    AudioService.instance.stopSong();
    Haptics.medium();
    final stars = _calculateStars();
    StorageService.setHighScore(widget.song.id, _score);
    StorageService.setStars(widget.song.id, stars);
    StorageService.setBestCombo(_maxCombo);
  }

  int _calculateStars() {
    if (_songProgress >= 0.95) return 3;
    if (_songProgress >= 0.65) return 2;
    if (_songProgress >= 0.35) return 1;
    return 0;
  }

  void _onPointerDown(PointerDownEvent event, Size screenSize) {
    if (_status == GameStatus.gameOver || _status == GameStatus.victory || _status == GameStatus.paused) {
      return;
    }

    if (event.localPosition.dy < 75) {
      return;
    }

    final laneWidth = screenSize.width / 4;
    final tapX = event.localPosition.dx;
    final tapY = event.localPosition.dy;
    final tapLane = (tapX / laneWidth).floor().clamp(0, 3);
    final tapYFraction = tapY / screenSize.height;

    final unhitTiles = _tiles.where((t) => !t.isHit && !t.isHolding && !t.isMissed).toList();
    final laneCandidates = unhitTiles.where((t) => t.lane == tapLane).toList();

    laneCandidates.sort((a, b) => b.y.compareTo(a.y));
    GameTile? hitTile;
    for (final t in laneCandidates) {
      final tileTop = t.y - (_tileHeightFactor * t.length);
      final isDirectTap = tapYFraction >= (tileTop - 0.08) && tapYFraction <= (t.y + 0.08);
      final isTargetLineHit = (t.y >= _targetLineFactor - 0.18 && tileTop <= _targetLineFactor + 0.18) &&
          ((tapYFraction - _targetLineFactor).abs() <= 0.18);
      if (isDirectTap || isTargetLineHit) {
        hitTile = t;
        break;
      }
    }

    if (hitTile == null) {
      _triggerGameOver(tapLane, Offset(tapX, tapY));
      return;
    }

    final hasLowerMissed = unhitTiles.any(
      (t) => t.id < hitTile!.id && (t.y - (_tileHeightFactor * t.length)) > 1.0,
    );
    if (hasLowerMissed) {
      _triggerGameOver(tapLane, Offset(tapX, tapY));
      return;
    }

    if (_status == GameStatus.ready) {
      if (hitTile.id != 0) {
        _triggerGameOver(tapLane, Offset(tapX, tapY));
        return;
      }
      _startGame();
    }

    Haptics.light();

    final tileTop = hitTile.y - (_tileHeightFactor * hitTile.length);
    double dist;
    if (_targetLineFactor >= tileTop && _targetLineFactor <= hitTile.y) {
      dist = 0.0;
    } else {
      dist = min((hitTile.y - _targetLineFactor).abs(), (tileTop - _targetLineFactor).abs());
    }

    HitQuality quality;
    int addScore;
    String label;

    if (dist < 0.05) {
      quality = HitQuality.perfect;
      addScore = 100;
      label = 'PERFECT!';
    } else if (dist < 0.11) {
      quality = HitQuality.great;
      addScore = 80;
      label = 'GREAT!';
    } else {
      quality = HitQuality.good;
      addScore = 50;
      label = 'GOOD';
    }

    _combo++;
    if (_combo > _maxCombo) _maxCombo = _combo;
    _score += addScore + (_combo * 2);

    if (hitTile.isLong) {
      hitTile.isHolding = true;
      hitTile.holdProgress = 0.0;
      _activePointerTiles[event.pointer] = hitTile.id;
    } else {
      hitTile.isHit = true;
    }

    _feedbacks.add(
      HitFeedback(
        text: label,
        quality: quality,
        x: tapX,
        y: tapY,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    setState(() {});
  }

  void _onPointerMove(PointerMoveEvent event, Size screenSize) {
    final tileId = _activePointerTiles[event.pointer];
    if (tileId != null) {
      final tile = _tiles.where((t) => t.id == tileId).firstOrNull;
      if (tile != null && tile.isHolding) {
        final laneWidth = screenSize.width / 4;
        final currentLane = (event.localPosition.dx / laneWidth).floor().clamp(0, 3);
        if (currentLane != tile.lane) {
          tile.isHolding = false;
          tile.isHit = true;
          _activePointerTiles.remove(event.pointer);
        }
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final tileId = _activePointerTiles.remove(event.pointer);
    if (tileId != null) {
      for (final tile in _tiles) {
        if (tile.id == tileId && tile.isHolding) {
          tile.isHolding = false;
          tile.isHit = true;
          if (tile.holdProgress >= 0.85) {
            _score += 100;
            Haptics.medium();
          }
        }
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    final tileId = _activePointerTiles.remove(event.pointer);
    if (tileId != null) {
      for (final tile in _tiles) {
        if (tile.id == tileId && tile.isHolding) {
          tile.isHolding = false;
          tile.isHit = true;
        }
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    AudioService.instance.stopSong();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.appTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                _screenSize = size;
                return Listener(
                  onPointerDown: (e) => _onPointerDown(e, size),
                  onPointerMove: (e) => _onPointerMove(e, size),
                  onPointerUp: _onPointerUp,
                  onPointerCancel: _onPointerCancel,
                  child: CustomPaint(
                    size: size,
                    painter: _GameTilesPainter(
                      tiles: _tiles,
                      feedbacks: _feedbacks,
                      appTheme: theme,
                      failedLane: _failedLane,
                      isReady: _status == GameStatus.ready,
                      targetLineFactor: _targetLineFactor,
                      tileHeightFactor: _tileHeightFactor,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(theme),
          ),
          if (_status == GameStatus.paused) _buildPauseOverlay(theme),
          if (_status == GameStatus.gameOver) _buildEndOverlay(theme, isWin: false),
          if (_status == GameStatus.victory) _buildEndOverlay(theme, isWin: true),
        ],
      ),
    );
  }

  Widget _buildHeader(AppThemeData theme) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.82),
            border: Border(
              bottom: BorderSide(
                color: theme.border.withValues(alpha: 0.4),
                width: 1.8,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.textPrimary, size: 22),
                        onPressed: () {
                          Haptics.select();
                          Navigator.of(context).pop();
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            '$_score',
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: theme.textPrimary,
                            ),
                          ),
                          if (_combo > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.playBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_combo}x COMBO',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _status == GameStatus.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          color: theme.textPrimary,
                          size: 28,
                        ),
                        onPressed: () {
                          Haptics.select();
                          if (_status == GameStatus.playing || _status == GameStatus.ready) {
                            _pauseGame();
                          } else if (_status == GameStatus.paused) {
                            _resumeGame();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _songProgress,
                      minHeight: 6,
                      backgroundColor: theme.surfaceVariant.withValues(alpha: 0.6),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.playBg),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay(AppThemeData theme) {
    return Container(
      color: Colors.black.withValues(alpha: 0.65),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.dialogBg,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Haptics.select();
                  _resumeGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.playBg,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: BorderSide(color: theme.border, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'HOME',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndOverlay(AppThemeData theme, {required bool isWin}) {
    final stars = _calculateStars();
    final highScore = StorageService.getHighScore(widget.song.id);

    return Container(
      color: Colors.black.withValues(alpha: 0.72),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.dialogBg,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWin ? 'SONG COMPLETED!' : 'OUT OF RHYTHM!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: isWin ? theme.playBg : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = i < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      active ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: active ? const Color(0xFFFFB800) : theme.border,
                      size: 38,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Score', style: TextStyle(color: theme.textMuted, fontWeight: FontWeight.w800)),
                        Text('$_score', style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Best Score', style: TextStyle(color: theme.textMuted, fontWeight: FontWeight.w800)),
                        Text('$highScore', style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  Haptics.select();
                  _initLevel();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWin ? theme.playBg : const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  isWin ? 'PLAY AGAIN' : 'TRY AGAIN',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: BorderSide(color: theme.border, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'HOME',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameTilesPainter extends CustomPainter {
  final List<GameTile> tiles;
  final List<HitFeedback> feedbacks;
  final AppThemeData appTheme;
  final int failedLane;
  final bool isReady;
  final double targetLineFactor;
  final double tileHeightFactor;

  _GameTilesPainter({
    required this.tiles,
    required this.feedbacks,
    required this.appTheme,
    required this.failedLane,
    required this.isReady,
    required this.targetLineFactor,
    required this.tileHeightFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final laneWidth = size.width / 4;

    final laneDividerPaint = Paint()
      ..color = appTheme.border.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;

    for (int i = 1; i < 4; i++) {
      final x = i * laneWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), laneDividerPaint);
    }

    final targetLineY = size.height * targetLineFactor;
    final targetLinePaint = Paint()
      ..color = appTheme.playBg.withValues(alpha: 0.55)
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(0, targetLineY), Offset(size.width, targetLineY), targetLinePaint);

    if (failedLane >= 0) {
      final failRect = Rect.fromLTWH(failedLane * laneWidth, 0, laneWidth, size.height);
      final failPaint = Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.35);
      canvas.drawRect(failRect, failPaint);
    }

    for (final tile in tiles) {
      if (tile.isHit && !tile.isHolding) continue;

      final tileX = tile.lane * laneWidth;
      final tileHeight = size.height * tileHeightFactor * tile.length;
      final tileY = (tile.y * size.height) - tileHeight;

      final rect = Rect.fromLTWH(tileX + 2.0, tileY, laneWidth - 4.0, tileHeight);

      if (tile.isLong) {
        final tailPaint = Paint()..color = appTheme.tileTailColor.withValues(alpha: 0.70);
        canvas.drawRect(rect, tailPaint);

        if (tile.isHolding) {
          final progressHeight = tileHeight * tile.holdProgress;
          final filledRect = Rect.fromLTWH(
            tileX + 2.0,
            tileY + tileHeight - progressHeight,
            laneWidth - 4.0,
            progressHeight,
          );
          final hitFillPaint = Paint()..color = appTheme.tileHitColor.withValues(alpha: 0.85);
          canvas.drawRect(filledRect, hitFillPaint);

          final contactY = tileY + tileHeight - progressHeight;
          final sparkPaint = Paint()
            ..color = Colors.white
            ..strokeWidth = 3.0;
          canvas.drawLine(Offset(tileX + 3.0, contactY), Offset(tileX + laneWidth - 3.0, contactY), sparkPaint);
        }

        final borderPaint = Paint()
          ..color = tile.isHolding ? appTheme.tileHitColor : appTheme.tileBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawRect(rect, borderPaint);

        final centerX = tileX + laneWidth / 2;
        final circleRadius = min(16.0, (laneWidth - 14) / 2);
        final circleCenter = Offset(centerX, tileY + tileHeight - circleRadius - 8);
        final lineTop = tileY + 8;
        final lineBottom = circleCenter.dy - circleRadius;

        if (lineBottom > lineTop) {
          final linePaint = Paint()
            ..color = Colors.white.withValues(alpha: tile.isHolding ? 0.95 : 0.75)
            ..strokeWidth = 3.5
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(Offset(centerX, lineTop), Offset(centerX, lineBottom), linePaint);
          canvas.drawCircle(Offset(centerX, lineTop), 3.5, linePaint);
        }

        final circlePaint = Paint()
          ..color = tile.isHolding ? appTheme.tileHitColor : Colors.white.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(circleCenter, circleRadius, circlePaint);

        final circleBorder = Paint()
          ..color = tile.isHolding ? Colors.white : appTheme.tileBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        canvas.drawCircle(circleCenter, circleRadius, circleBorder);

        final innerDot = Paint()
          ..color = tile.isHolding ? Colors.white : appTheme.tileColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(circleCenter, circleRadius * 0.45, innerDot);
      } else {
        final tilePaint = Paint()..color = appTheme.tileColor;
        canvas.drawRect(rect, tilePaint);

        final borderPaint = Paint()
          ..color = appTheme.tileBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawRect(rect, borderPaint);
      }

      if (isReady && tile.id == 0) {
        final tp = TextPainter(
          text: const TextSpan(
            text: 'START',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: 'Fredoka',
              letterSpacing: 1.5,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            tileX + (laneWidth - tp.width) / 2,
            tileY + (tileHeight - tp.height) / 2,
          ),
        );
      }
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    for (final fb in feedbacks) {
      final elapsed = now - fb.timestamp;
      final progress = (elapsed / 700.0).clamp(0.0, 1.0);
      final alpha = (1.0 - progress).clamp(0.0, 1.0);
      final floatOffset = progress * 36.0;

      Color color;
      switch (fb.quality) {
        case HitQuality.perfect:
          color = const Color(0xFFFFB800);
          break;
        case HitQuality.great:
          color = appTheme.playBg;
          break;
        case HitQuality.good:
          color = appTheme.songsBg;
          break;
        default:
          color = const Color(0xFFEF4444);
      }

      final tp = TextPainter(
        text: TextSpan(
          text: fb.text,
          style: TextStyle(
            color: color.withValues(alpha: alpha),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontFamily: 'Fredoka',
            letterSpacing: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(fb.x - (tp.width / 2), fb.y - floatOffset - (tp.height / 2)));
    }
  }

  @override
  bool shouldRepaint(covariant _GameTilesPainter oldDelegate) => true;
}
