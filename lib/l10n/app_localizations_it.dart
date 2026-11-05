// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get tagline => 'TOCCA A RITMO';

  @override
  String get addSong => 'AGGIUNGI CANZONE';

  @override
  String get songName => 'Nome canzone';

  @override
  String get songNameHint => 'Inserisci il titolo';

  @override
  String get chooseAudio => 'Scegli audio';

  @override
  String get cancel => 'ANNULLA';

  @override
  String get add => 'AGGIUNGI';

  @override
  String get addYourSong => 'Aggiungi la tua canzone';

  @override
  String get howToPlay => 'Come si gioca';

  @override
  String get noSongsYet => 'NESSUNA CANZONE';

  @override
  String get noSongsHint =>
      'Aggiungi i tuoi file audio qui sotto per iniziare a giocare!';

  @override
  String bestScoreShort(int score) {
    return 'RECORD: $score';
  }

  @override
  String get customArtist => 'Personalizzata';

  @override
  String get settingsTitle => 'IMPOSTAZIONI';

  @override
  String get hapticsSection => 'VIBRAZIONE';

  @override
  String get hapticFeedback => 'Feedback tattile';

  @override
  String get themeSection => 'TEMA';

  @override
  String get languageSection => 'LINGUA';

  @override
  String get systemDefault => 'Lingua di sistema';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get resetHighScores => 'AZZERA RECORD';

  @override
  String get resetScoresTitle => 'Azzerare i record?';

  @override
  String get resetScoresMessage =>
      'Vuoi davvero azzerare tutti i record e le stelle salvate?';

  @override
  String get reset => 'AZZERA';

  @override
  String get themeNameClean => 'Chiaro';

  @override
  String get themeNameDark => 'Scuro';

  @override
  String get themeNameAmoled => 'AMOLED Scuro';

  @override
  String get themeNameForest => 'Foresta';

  @override
  String get themeNameOcean => 'Oceano';

  @override
  String get themeNameSunset => 'Tramonto';

  @override
  String get paused => 'PAUSA';

  @override
  String get resume => 'RIPRENDI';

  @override
  String get home => 'HOME';

  @override
  String get songCompleted => 'CANZONE COMPLETATA!';

  @override
  String get outOfRhythm => 'FUORI RITMO!';

  @override
  String get score => 'Punteggio';

  @override
  String get bestScore => 'Record';

  @override
  String get playAgain => 'RIGIOCA';

  @override
  String get tryAgain => 'RIPROVA';

  @override
  String get start => 'START';

  @override
  String get qualityPerfect => 'PERFETTO!';

  @override
  String get qualityGreat => 'OTTIMO!';

  @override
  String get qualityGood => 'BUONO';

  @override
  String get qualityMiss => 'MANCATO!';

  @override
  String comboLabel(int combo) {
    return '${combo}x COMBO';
  }

  @override
  String get howToPlayTitle => 'COME SI GIOCA';

  @override
  String get singleTapTitle => 'TILES A TOCCO SINGOLO';

  @override
  String get singleTapSubtitle =>
      'Tocca ogni tile proprio quando raggiunge la linea in basso.';

  @override
  String get singleTapPoint1 =>
      'Tocca quando il tile raggiunge la linea di giudizio bianca.';

  @override
  String get singleTapPoint2 =>
      'Toccare più vicino al centro assegna la valutazione PERFETTO!.';

  @override
  String get singleTapPoint3 => 'Un singolo tocco rimuove subito il tile.';

  @override
  String get holdTilesTitle => 'TIENI PREMUTO I TILES';

  @override
  String get holdTilesSubtitle =>
      'Riconoscibili dalla testa circolare e dalla linea retta.';

  @override
  String get holdTilesPoint1 =>
      'Tocca la testa circolare quando raggiunge la linea, poi tieni premuto.';

  @override
  String get holdTilesPoint2 =>
      'Mantenere premuto carica punti bonus e aumenta il tuo combo.';

  @override
  String get holdTilesPoint3 =>
      'Rilasciare in anticipo non causa game over: qualsiasi tocco o pressione prolungata è valida!';

  @override
  String get avoidMistakesTitle => 'EVITA GLI ERRORI';

  @override
  String get avoidMistakesSubtitle => 'Non interrompere la tua canzone.';

  @override
  String get avoidMistakesPoint1 =>
      'Non toccare mai una corsia vuota in cui non sta passando nessun tile.';

  @override
  String get avoidMistakesPoint2 =>
      'Non lasciare che i tile superino il fondo dello schermo senza toccarli.';

  @override
  String get avoidMistakesPoint3 =>
      'Usa più dita per le canzoni con BPM veloci.';

  @override
  String get judgmentLine => 'LINEA DI GIUDIZIO';

  @override
  String get tap => 'TOCCA';

  @override
  String get chargingCombo => 'COMBO IN CARICA';

  @override
  String get missTriggerTitle => 'ERRORE FATALE';

  @override
  String get missTriggerText =>
      'Toccare spazi vuoti o lasciare cadere i tile senza toccarli termina subito la partita.';

  @override
  String get gotItLetsPlay => 'CHIARO, GIOCHIAMO!';
}
