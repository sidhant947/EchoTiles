import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';

class StorageService {
  static const String keyTheme = 'theme_id';
  static const String keyHaptic = 'haptic_enabled';
  static const String keySound = 'sound_enabled';
  static const String keyBestCombo = 'best_combo';
  static const String keyCustomSongs = 'custom_songs';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getThemeId() {
    return _prefs.getString(keyTheme) ?? 'amoled';
  }

  static Future<void> setThemeId(String themeId) async {
    await _prefs.setString(keyTheme, themeId);
  }

  static bool getHapticEnabled() {
    return _prefs.getBool(keyHaptic) ?? true;
  }

  static Future<void> setHapticEnabled(bool value) async {
    await _prefs.setBool(keyHaptic, value);
  }

  static bool getSoundEnabled() {
    return _prefs.getBool(keySound) ?? true;
  }

  static Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool(keySound, value);
  }

  static int getHighScore(String songId) {
    return _prefs.getInt('high_score_$songId') ?? 0;
  }

  static Future<void> setHighScore(String songId, int score) async {
    final current = getHighScore(songId);
    if (score > current) {
      await _prefs.setInt('high_score_$songId', score);
    }
  }

  static int getStars(String songId) {
    return _prefs.getInt('stars_$songId') ?? 0;
  }

  static Future<void> setStars(String songId, int stars) async {
    final current = getStars(songId);
    if (stars > current) {
      await _prefs.setInt('stars_$songId', stars);
    }
  }

  static int getBestCombo() {
    return _prefs.getInt(keyBestCombo) ?? 0;
  }

  static Future<void> setBestCombo(int combo) async {
    final current = getBestCombo();
    if (combo > current) {
      await _prefs.setInt(keyBestCombo, combo);
    }
  }

  static List<SongItem> getCustomSongs() {
    final raw = _prefs.getStringList(keyCustomSongs) ?? [];
    return raw
        .map((str) => SongItem.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addCustomSong(SongItem song) async {
    final current = getCustomSongs();
    current.add(song);
    final raw = current.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(keyCustomSongs, raw);
  }

  static Future<void> removeCustomSong(String songId) async {
    final current = getCustomSongs();
    current.removeWhere((s) => s.id == songId);
    final raw = current.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(keyCustomSongs, raw);
  }

  static Future<void> resetHighScores() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('high_score_') || key.startsWith('stars_') || key == keyBestCombo) {
        await _prefs.remove(key);
      }
    }
  }

  static Future<void> resetAll() async {
    await resetHighScores();
  }
}
