import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'TAP TO THE BEAT'**
  String get tagline;

  /// No description provided for @addSong.
  ///
  /// In en, this message translates to:
  /// **'ADD SONG'**
  String get addSong;

  /// No description provided for @songName.
  ///
  /// In en, this message translates to:
  /// **'Song Name'**
  String get songName;

  /// No description provided for @songNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter song title'**
  String get songNameHint;

  /// No description provided for @chooseAudio.
  ///
  /// In en, this message translates to:
  /// **'Choose Audio'**
  String get chooseAudio;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get add;

  /// No description provided for @addYourSong.
  ///
  /// In en, this message translates to:
  /// **'Add your song'**
  String get addYourSong;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlay;

  /// No description provided for @noSongsYet.
  ///
  /// In en, this message translates to:
  /// **'NO SONGS YET'**
  String get noSongsYet;

  /// No description provided for @noSongsHint.
  ///
  /// In en, this message translates to:
  /// **'Add your audio files below to start playing!'**
  String get noSongsHint;

  /// No description provided for @bestScoreShort.
  ///
  /// In en, this message translates to:
  /// **'BEST: {score}'**
  String bestScoreShort(int score);

  /// No description provided for @customArtist.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customArtist;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @hapticsSection.
  ///
  /// In en, this message translates to:
  /// **'HAPTICS'**
  String get hapticsSection;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @themeSection.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get themeSection;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get languageSection;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get langItalian;

  /// No description provided for @resetHighScores.
  ///
  /// In en, this message translates to:
  /// **'RESET HIGH SCORES'**
  String get resetHighScores;

  /// No description provided for @resetScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Scores?'**
  String get resetScoresTitle;

  /// No description provided for @resetScoresMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all saved high scores and stars?'**
  String get resetScoresMessage;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get reset;

  /// No description provided for @themeNameClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get themeNameClean;

  /// No description provided for @themeNameDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeNameDark;

  /// No description provided for @themeNameAmoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED Dark'**
  String get themeNameAmoled;

  /// No description provided for @themeNameForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeNameForest;

  /// No description provided for @themeNameOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get themeNameOcean;

  /// No description provided for @themeNameSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get themeNameSunset;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home;

  /// No description provided for @songCompleted.
  ///
  /// In en, this message translates to:
  /// **'SONG COMPLETED!'**
  String get songCompleted;

  /// No description provided for @outOfRhythm.
  ///
  /// In en, this message translates to:
  /// **'OUT OF RHYTHM!'**
  String get outOfRhythm;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best Score'**
  String get bestScore;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'PLAY AGAIN'**
  String get playAgain;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgain;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @qualityPerfect.
  ///
  /// In en, this message translates to:
  /// **'PERFECT!'**
  String get qualityPerfect;

  /// No description provided for @qualityGreat.
  ///
  /// In en, this message translates to:
  /// **'GREAT!'**
  String get qualityGreat;

  /// No description provided for @qualityGood.
  ///
  /// In en, this message translates to:
  /// **'GOOD'**
  String get qualityGood;

  /// No description provided for @qualityMiss.
  ///
  /// In en, this message translates to:
  /// **'MISS!'**
  String get qualityMiss;

  /// No description provided for @comboLabel.
  ///
  /// In en, this message translates to:
  /// **'{combo}x COMBO'**
  String comboLabel(int combo);

  /// No description provided for @howToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY'**
  String get howToPlayTitle;

  /// No description provided for @singleTapTitle.
  ///
  /// In en, this message translates to:
  /// **'SINGLE TAP TILES'**
  String get singleTapTitle;

  /// No description provided for @singleTapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap each tile right as it hits the bottom line.'**
  String get singleTapSubtitle;

  /// No description provided for @singleTapPoint1.
  ///
  /// In en, this message translates to:
  /// **'Tap when the tile reaches the white judgment line.'**
  String get singleTapPoint1;

  /// No description provided for @singleTapPoint2.
  ///
  /// In en, this message translates to:
  /// **'Tapping closer to the center gives PERFECT! rating.'**
  String get singleTapPoint2;

  /// No description provided for @singleTapPoint3.
  ///
  /// In en, this message translates to:
  /// **'A single tap clears the tile immediately.'**
  String get singleTapPoint3;

  /// No description provided for @holdTilesTitle.
  ///
  /// In en, this message translates to:
  /// **'HOLD TILES'**
  String get holdTilesTitle;

  /// No description provided for @holdTilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Identified by the circle head and straight line.'**
  String get holdTilesSubtitle;

  /// No description provided for @holdTilesPoint1.
  ///
  /// In en, this message translates to:
  /// **'Tap the circle head when it hits the line, then keep holding.'**
  String get holdTilesPoint1;

  /// No description provided for @holdTilesPoint2.
  ///
  /// In en, this message translates to:
  /// **'Holding charges bonus points and builds your combo.'**
  String get holdTilesPoint2;

  /// No description provided for @holdTilesPoint3.
  ///
  /// In en, this message translates to:
  /// **'Releasing early won\'t cause a game over—any tap or hold is valid!'**
  String get holdTilesPoint3;

  /// No description provided for @avoidMistakesTitle.
  ///
  /// In en, this message translates to:
  /// **'AVOID MISTAKES'**
  String get avoidMistakesTitle;

  /// No description provided for @avoidMistakesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your song streak alive.'**
  String get avoidMistakesSubtitle;

  /// No description provided for @avoidMistakesPoint1.
  ///
  /// In en, this message translates to:
  /// **'Never tap an empty lane where no tile is passing.'**
  String get avoidMistakesPoint1;

  /// No description provided for @avoidMistakesPoint2.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let tiles scroll past the bottom without touching them.'**
  String get avoidMistakesPoint2;

  /// No description provided for @avoidMistakesPoint3.
  ///
  /// In en, this message translates to:
  /// **'Play with multiple fingers for fast BPM songs.'**
  String get avoidMistakesPoint3;

  /// No description provided for @judgmentLine.
  ///
  /// In en, this message translates to:
  /// **'JUDGMENT LINE'**
  String get judgmentLine;

  /// No description provided for @tap.
  ///
  /// In en, this message translates to:
  /// **'TAP'**
  String get tap;

  /// No description provided for @chargingCombo.
  ///
  /// In en, this message translates to:
  /// **'CHARGING COMBO'**
  String get chargingCombo;

  /// No description provided for @missTriggerTitle.
  ///
  /// In en, this message translates to:
  /// **'MISS TRIGGER'**
  String get missTriggerTitle;

  /// No description provided for @missTriggerText.
  ///
  /// In en, this message translates to:
  /// **'Tapping empty spaces or letting tiles fall through ends your run immediately.'**
  String get missTriggerText;

  /// No description provided for @gotItLetsPlay.
  ///
  /// In en, this message translates to:
  /// **'GOT IT, LET\'S PLAY!'**
  String get gotItLetsPlay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
