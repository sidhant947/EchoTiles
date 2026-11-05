import '../models/game_models.dart';
import 'storage_service.dart';

class SongCatalog {
  static const List<SongItem> defaultSongs = [
    SongItem(
      id: 'default_brain_dance',
      title: 'Brain Dance',
      artist: 'Kevin MacLeod',
      assetAudio: 'assets/songs/Brain Dance.mp3',
      bpm: 124.0,
      notesCount: 494,
    ),
  ];

  static List<SongItem> getSongs() {
    final customSongs = StorageService.getCustomSongs();
    final allSongs = [...defaultSongs, ...customSongs];
    return allSongs.map((song) {
      final hs = StorageService.getHighScore(song.id);
      final st = StorageService.getStars(song.id);
      return song.copyWith(highScore: hs, stars: st);
    }).toList();
  }

  static SongItem? getSongById(String id) {
    final list = getSongs();
    for (final s in list) {
      if (s.id == id) return s;
    }
    return null;
  }
}
