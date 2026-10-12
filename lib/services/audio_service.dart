import 'package:audioplayers/audioplayers.dart';
import 'storage_service.dart';

class AudioService {
  static final AudioService instance = AudioService._internal();

  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  Duration? _currentDuration;

  Duration? get currentDuration => _currentDuration;
  Stream<Duration> get onDurationChanged => _musicPlayer.onDurationChanged;
  Stream<Duration> get onPositionChanged => _musicPlayer.onPositionChanged;
  Stream<void> get onPlayerComplete => _musicPlayer.onPlayerComplete;

  Future<void> init() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.stop);
    await _musicPlayer.setVolume(1.0);
    _musicPlayer.onDurationChanged.listen((d) {
      _currentDuration = d;
    });
  }

  Future<Duration?> getDuration() async {
    try {
      _currentDuration = await _musicPlayer.getDuration();
    } catch (_) {}
    return _currentDuration;
  }

  Future<Duration?> getCurrentPosition() async {
    try {
      return await _musicPlayer.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  static Future<Duration?> getAudioDuration(String audioPath) async {
    final player = AudioPlayer();
    try {
      if (audioPath.startsWith('assets/')) {
        await player.setSource(AssetSource(audioPath.substring(7)));
      } else if (audioPath.startsWith('content://') ||
          audioPath.startsWith('http://') ||
          audioPath.startsWith('https://')) {
        await player.setSource(UrlSource(audioPath));
      } else {
        await player.setSource(DeviceFileSource(audioPath));
      }
      final duration = await player.getDuration();
      await player.dispose();
      return duration;
    } catch (_) {
      await player.dispose();
      return null;
    }
  }

  Future<void> playSong(String audioPath) async {
    if (!StorageService.getSoundEnabled()) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setVolume(1.0);
      if (audioPath.startsWith('assets/')) {
        final cleanPath = audioPath.substring(7);
        await _musicPlayer.play(AssetSource(cleanPath));
      } else if (audioPath.startsWith('content://') ||
          audioPath.startsWith('http://') ||
          audioPath.startsWith('https://')) {
        await _musicPlayer.play(UrlSource(audioPath));
      } else {
        await _musicPlayer.play(DeviceFileSource(audioPath));
      }
      _currentDuration = await _musicPlayer.getDuration();
    } catch (_) {}
  }

  Future<void> pauseSong() async {
    try {
      await _musicPlayer.pause();
    } catch (_) {}
  }

  Future<void> resumeSong() async {
    if (!StorageService.getSoundEnabled()) return;
    try {
      await _musicPlayer.resume();
    } catch (_) {}
  }

  Future<void> stopSong() async {
    try {
      await _musicPlayer.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _musicPlayer.dispose();
  }
}
