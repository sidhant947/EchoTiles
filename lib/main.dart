import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await AudioService.instance.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EchoTilesApp());
}

class EchoTilesApp extends StatefulWidget {
  const EchoTilesApp({super.key});

  @override
  State<EchoTilesApp> createState() => _EchoTilesAppState();
}

class _EchoTilesAppState extends State<EchoTilesApp> {
  late AppThemeData _theme;

  @override
  void initState() {
    super.initState();
    final savedThemeId = StorageService.getThemeId();
    _theme = AppThemes.fromName(savedThemeId);
  }

  void _onThemeChanged(AppThemeId id) {
    setState(() {
      _theme = AppThemes.fromId(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo Tiles',
      debugShowCheckedModeBanner: false,
      theme: _theme.toMaterialTheme(),
      home: HomeScreen(
        appTheme: _theme,
        onThemeChanged: _onThemeChanged,
      ),
    );
  }
}
