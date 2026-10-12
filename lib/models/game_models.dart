enum GameStatus { ready, playing, paused, gameOver, victory }

enum HitQuality { perfect, great, good, miss }

class SongItem {
  final String id;
  final String title;
  final String artist;
  final String assetAudio;
  final double bpm;
  final int notesCount;
  final int highScore;
  final int stars;

  const SongItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetAudio,
    required this.bpm,
    required this.notesCount,
    this.highScore = 0,
    this.stars = 0,
  });

  SongItem copyWith({
    int? highScore,
    int? stars,
  }) {
    return SongItem(
      id: id,
      title: title,
      artist: artist,
      assetAudio: assetAudio,
      bpm: bpm,
      notesCount: notesCount,
      highScore: highScore ?? this.highScore,
      stars: stars ?? this.stars,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'assetAudio': assetAudio,
      'bpm': bpm,
      'notesCount': notesCount,
      'highScore': highScore,
      'stars': stars,
    };
  }

  factory SongItem.fromJson(Map<String, dynamic> json) {
    return SongItem(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String? ?? 'Custom',
      assetAudio: json['assetAudio'] as String,
      bpm: (json['bpm'] as num?)?.toDouble() ?? 120.0,
      notesCount: (json['notesCount'] as num?)?.toInt() ?? 160,
      highScore: (json['highScore'] as num?)?.toInt() ?? 0,
      stars: (json['stars'] as num?)?.toInt() ?? 0,
    );
  }
}

class GameTile {
  final int id;
  final int lane;
  double y;
  final double length;
  final bool isLong;
  bool isHit;
  bool isHolding;
  double holdProgress;
  bool isMissed;
  final int noteIndex;

  GameTile({
    required this.id,
    required this.lane,
    required this.y,
    this.length = 1.0,
    this.isLong = false,
    this.isHit = false,
    this.isHolding = false,
    this.holdProgress = 0.0,
    this.isMissed = false,
    this.noteIndex = 0,
  });
}

class HitFeedback {
  final String text;
  final HitQuality quality;
  final double x;
  final double y;
  final int timestamp;

  const HitFeedback({
    required this.text,
    required this.quality,
    required this.x,
    required this.y,
    required this.timestamp,
  });
}
