import '../models/game_models.dart';
import 'storage_service.dart';

class SongCatalog {
  static const List<SongItem> defaultSongs = [];

  static List<SongItem> getSongs() {
    final allSongs = StorageService.getCustomSongs();
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
