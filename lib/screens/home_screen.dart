import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_theme.dart';
import '../models/game_models.dart';
import '../services/audio_service.dart';
import '../services/haptics.dart';
import '../services/song_catalog.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';
import 'how_to_play_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppThemeData appTheme;
  final ValueChanged<AppThemeId> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.appTheme,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<SongItem> _songs = const [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _songs = SongCatalog.getSongs();
    });
  }

  Future<void> _openUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _playSong(SongItem song) async {
    Haptics.select();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(song: song, appTheme: widget.appTheme),
      ),
    );
    _loadData();
  }

  Future<void> _showAddSongDialog() async {
    final titleController = TextEditingController();
    String? pickedFilePath;
    String? pickedFileName;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final theme = widget.appTheme;
            return AlertDialog(
              backgroundColor: theme.dialogBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                'ADD SONG',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: theme.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Song Name',
                        hintText: 'Enter song title',
                        labelStyle: TextStyle(color: theme.textMuted),
                        hintStyle: TextStyle(
                          color: theme.textMuted.withValues(alpha: 0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.border,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.playBg, width: 2),
                        ),
                      ),
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        Haptics.select();
                        final file = await FilePicker.pickFile(
                          type: FileType.audio,
                        );
                        if (file != null) {
                          setDialogState(() {
                            pickedFilePath = file.path ?? file.uri.toString();
                            pickedFileName = file.name;
                            if (titleController.text.trim().isEmpty) {
                              final nameWithoutExt = file.name.contains('.')
                                  ? file.name.substring(
                                      0,
                                      file.name.lastIndexOf('.'),
                                    )
                                  : file.name;
                              titleController.text = nameWithoutExt;
                            }
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        side: BorderSide(
                          color: pickedFilePath != null
                              ? theme.playBg
                              : theme.border,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        pickedFilePath != null
                            ? Icons.check_circle_rounded
                            : Icons.folder_open_rounded,
                        color: pickedFilePath != null
                            ? theme.playBg
                            : theme.textPrimary,
                        size: 20,
                      ),
                      label: Text(
                        pickedFileName ?? 'Choose Audio',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: pickedFilePath != null
                              ? theme.playBg
                              : theme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: theme.textMuted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.playBg,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    if (title.isEmpty || pickedFilePath == null) return;
                    final dur = await AudioService.getAudioDuration(pickedFilePath!);
                    final notesCount = dur != null && dur.inSeconds > 0
                        ? (dur.inSeconds * 2.3).round().clamp(60, 5000)
                        : 160;
                    final song = SongItem(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      artist: 'Custom',
                      assetAudio: pickedFilePath!,
                      bpm: 120,
                      notesCount: notesCount,
                    );
                    await StorageService.addCustomSong(song);
                    if (ctx.mounted) Navigator.pop(ctx);
                    _loadData();
                  },
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAddSongButton(AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: OutlinedButton.icon(
        onPressed: _showAddSongDialog,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          side: BorderSide(
            color: theme.playBg,
            width: 1.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(
          Icons.add_rounded,
          color: theme.playBg,
          size: 24,
        ),
        label: Text(
          'Add your song',
          style: TextStyle(
            color: theme.playBg,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildHowToPlayButton(AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton.icon(
        onPressed: () {
          Haptics.select();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HowToPlayScreen(appTheme: widget.appTheme),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          side: BorderSide(
            color: theme.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(
          Icons.help_outline_rounded,
          color: theme.textSecondary,
          size: 20,
        ),
        label: Text(
          'How to play',
          style: TextStyle(
            color: theme.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: theme.playBg.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.queue_music_rounded,
                      size: 40,
                      color: theme.playBg,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'NO SONGS YET',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your audio files below to start playing!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddSongButton(theme),
          _buildHowToPlayButton(theme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.appTheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.star_rounded, size: 28),
                color: const Color(0xFFEAB308),
                onPressed: () {
                  Haptics.select();
                  _openUrl('https://github.com/sidhant947/EchoTiles');
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, size: 26),
                  color: const Color(0xFFEF4444),
                  onPressed: () {
                    Haptics.select();
                    _openUrl('https://ko-fi.com/sidhant947');
                  },
                ),
              ],
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardBg,
          border: Border(top: BorderSide(color: theme.border, width: 1.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.cardBg,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: theme.playBg,
          unselectedItemColor: theme.textMuted,
          onTap: (index) {
            Haptics.select();
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              _loadData();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded, size: 26),
              label: '',
            ),
          ],
        ),
      ),
      body: _currentIndex == 0
          ? SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'ECHO TILES',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.5,
                              color: theme.textPrimary,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TAP TO THE BEAT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: theme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _songs.isEmpty
                        ? _buildEmptyState(theme)
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            itemCount: _songs.length + 1,
                            separatorBuilder: (_, _) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              if (index == _songs.length) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildAddSongButton(theme),
                                    _buildHowToPlayButton(theme),
                                  ],
                                );
                              }
                              final song = _songs[index];
                        return GestureDetector(
                          onTap: () => _playSong(song),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.border,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        style: TextStyle(
                                          fontFamily: 'Fredoka',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: theme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        song.artist,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: theme.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(3, (
                                              starIdx,
                                            ) {
                                              final active =
                                                  starIdx < song.stars;
                                              return Icon(
                                                active
                                                    ? Icons.star_rounded
                                                    : Icons
                                                          .star_outline_rounded,
                                                color: active
                                                    ? const Color(0xFFFFB800)
                                                    : theme.border,
                                                size: 16,
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 10),
                                          if (song.highScore > 0)
                                            Text(
                                              'BEST: ${song.highScore}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: theme.playBg,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (song.id.startsWith('custom_')) ...[
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: theme.textMuted,
                                      size: 22,
                                    ),
                                    onPressed: () async {
                                      Haptics.select();
                                      await StorageService.removeCustomSong(
                                        song.id,
                                      );
                                      _loadData();
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: theme.playBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : SettingsScreen(
              appTheme: widget.appTheme,
              onThemeChanged: widget.onThemeChanged,
            ),
    );
  }
}
