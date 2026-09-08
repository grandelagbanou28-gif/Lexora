// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(attemptNumber) =>
      "I couldn\'t guess the word in ${attemptNumber} attempts.";

  static String m1(attemptNumber) =>
      "The word is solved in ${attemptNumber}/6 attempts.";

  static String m2(number) => "Level ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "appDictionary": MessageLookupByLibrary.simpleMessage("App dictionary"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("App language"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Lexora"),
    "casual": MessageLookupByLibrary.simpleMessage("Default"),
    "checkResult": MessageLookupByLibrary.simpleMessage(
      "You can check your result here:",
    ),
    "checkResultLose": m0,
    "checkResultWin": m1,
    "colorMode": MessageLookupByLibrary.simpleMessage("Color mode"),
    "contact": MessageLookupByLibrary.simpleMessage(
      "If you didn\'t find a word in the dictionary\nor it has the wrong definition,\nwrite to us, we will add it\nin the next update.\n",
    ),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Current\nStreak"),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "examples": MessageLookupByLibrary.simpleMessage("Examples"),
    "guessDistribution": MessageLookupByLibrary.simpleMessage(
      "Guess distribution",
    ),
    "highContrast": MessageLookupByLibrary.simpleMessage("High contrast"),
    "levelNumber": m2,
    "levels": MessageLookupByLibrary.simpleMessage("Levels"),
    "loseMessage": MessageLookupByLibrary.simpleMessage("You lost"),
    "maxStreak": MessageLookupByLibrary.simpleMessage("Max\nStreak"),
    "newWordAvailableEachDay": MessageLookupByLibrary.simpleMessage(
      "A new word will be available each day!",
    ),
    "nextLevel": MessageLookupByLibrary.simpleMessage("Next level"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Next word in"),
    "notPlayed": MessageLookupByLibrary.simpleMessage(
      "You haven\'t played a single game",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "played": MessageLookupByLibrary.simpleMessage("Played"),
    "progressSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Could not save progress. Your board is still available.",
    ),
    "resultUnavailable": MessageLookupByLibrary.simpleMessage(
      "Result unavailable",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "fon": MessageLookupByLibrary.simpleMessage("Fon"),
    "fr": MessageLookupByLibrary.simpleMessage("French"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "secretWord": MessageLookupByLibrary.simpleMessage("Secret word"),
    "sendMessage": MessageLookupByLibrary.simpleMessage(
      "subject=Lexora%20-%20New%20word&body=Word%20-%0AMeaning%20-",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "start": MessageLookupByLibrary.simpleMessage("Start game"),
    "statistic": MessageLookupByLibrary.simpleMessage("Statistic"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("System"),
    "tutorial": MessageLookupByLibrary.simpleMessage("How to play"),
    "tutorialDescription1": MessageLookupByLibrary.simpleMessage(
      "Each guess must be a valid 5 letter word. Hit the enter button to submit.",
    ),
    "tutorialDescription2": MessageLookupByLibrary.simpleMessage(
      "After each guess, the color of the tiles will change to show how close your guess was to the word.",
    ),
    "tutorialNotInWordSpot": MessageLookupByLibrary.simpleMessage(
      "The letter E is not in the word in any spot.",
    ),
    "tutorialTitle": MessageLookupByLibrary.simpleMessage(
      "Guess the WORD in 6 tries.",
    ),
    "tutorialWordCorrectSpot": MessageLookupByLibrary.simpleMessage(
      "The letter P is in the word and in the correct spot.",
    ),
    "tutorialWordWrongSpot": MessageLookupByLibrary.simpleMessage(
      "The letter A is in the word but in the wrong spot.",
    ),
    "viewLevels": MessageLookupByLibrary.simpleMessage("View levels"),
    "viewStatistic": MessageLookupByLibrary.simpleMessage("View statistic"),
    "winMessage": MessageLookupByLibrary.simpleMessage("You win!"),
    "winRate": MessageLookupByLibrary.simpleMessage("Win\nrate"),
    "wordNotFound": MessageLookupByLibrary.simpleMessage(
      "Word not found in dictionary",
    ),
    "wordTooShort": MessageLookupByLibrary.simpleMessage(
      "Word is not correct length",
    ),
    "achFiftyLevels": MessageLookupByLibrary.simpleMessage(
      "Fifty levels",
    ),
    "achFiftyLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Complete 50 levels",
    ),
    "achFirstWin": MessageLookupByLibrary.simpleMessage(
      "First win",
    ),
    "achFirstWinDesc": MessageLookupByLibrary.simpleMessage(
      "Win your first game",
    ),
    "achFiveWins": MessageLookupByLibrary.simpleMessage(
      "Five wins",
    ),
    "achFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Win 5 games",
    ),
    "achHintUser": MessageLookupByLibrary.simpleMessage(
      "Hint master",
    ),
    "achHintUserDesc": MessageLookupByLibrary.simpleMessage(
      "Use a hint 3 times",
    ),
    "achRich": MessageLookupByLibrary.simpleMessage(
      "Treasure",
    ),
    "achRichDesc": MessageLookupByLibrary.simpleMessage(
      "Hold 500 tokens",
    ),
    "achStreak3": MessageLookupByLibrary.simpleMessage(
      "Streak of 3 wins",
    ),
    "achStreak3Desc": MessageLookupByLibrary.simpleMessage(
      "Win 3 daily games in a row",
    ),
    "achStreak7": MessageLookupByLibrary.simpleMessage(
      "Streak of 7 wins",
    ),
    "achStreak7Desc": MessageLookupByLibrary.simpleMessage(
      "Win 7 daily games in a row",
    ),
    "achTenLevels": MessageLookupByLibrary.simpleMessage(
      "Ten levels",
    ),
    "achTenLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Complete 10 levels",
    ),
    "achTwentyFiveWins": MessageLookupByLibrary.simpleMessage(
      "25 wins",
    ),
    "achTwentyFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Win 25 games",
    ),
    "achievements": MessageLookupByLibrary.simpleMessage(
      "Achievements",
    ),
    "achievementsLocked": MessageLookupByLibrary.simpleMessage(
      "Locked",
    ),
    "achievementsUnlocked": MessageLookupByLibrary.simpleMessage(
      "Achievement unlocked!",
    ),
    "balance": MessageLookupByLibrary.simpleMessage(
      "Balance",
    ),
    "challengeCompleted": MessageLookupByLibrary.simpleMessage(
      "Challenge completed!",
    ),
    "challengeReward": MessageLookupByLibrary.simpleMessage(
      "Reward",
    ),
    "dailyChallengeFast": MessageLookupByLibrary.simpleMessage(
      "Win in 4 tries or less",
    ),
    "dailyChallengeStreak": MessageLookupByLibrary.simpleMessage(
      "Win 3 daily games in a row",
    ),
    "dailyChallengeWord": MessageLookupByLibrary.simpleMessage(
      "Complete today’s word",
    ),
    "dailyChallenges": MessageLookupByLibrary.simpleMessage(
      "Daily challenges",
    ),
    "earnTip": MessageLookupByLibrary.simpleMessage(
      "Win games to earn tokens and XP!",
    ),
    "eliminateLetters": MessageLookupByLibrary.simpleMessage(
      "Eliminate letters",
    ),
    "hintShop": MessageLookupByLibrary.simpleMessage(
      "Hint shop",
    ),
    "hints": MessageLookupByLibrary.simpleMessage(
      "Hints",
    ),
    "levelUpMessage": MessageLookupByLibrary.simpleMessage(
      "You reached a new level",
    ),
    "levelUpTitle": MessageLookupByLibrary.simpleMessage(
      "Level up!",
    ),
    "notEnoughTokens": MessageLookupByLibrary.simpleMessage(
      "Not enough tokens",
    ),
    "playerLevel": MessageLookupByLibrary.simpleMessage(
      "Player level",
    ),
    "profile": MessageLookupByLibrary.simpleMessage(
      "Profile",
    ),
    "revealLetter": MessageLookupByLibrary.simpleMessage(
      "Reveal a letter",
    ),
    "rowIsFullFirst": MessageLookupByLibrary.simpleMessage(
      "Complete the current word first",
    ),
    "sound": MessageLookupByLibrary.simpleMessage(
      "Sound effects",
    ),
    "tokens": MessageLookupByLibrary.simpleMessage(
      "Tokens",
    ),
    "vibration": MessageLookupByLibrary.simpleMessage(
      "Vibration",
    ),
    "xp": MessageLookupByLibrary.simpleMessage(
      "XP",
    ),
  };
}
