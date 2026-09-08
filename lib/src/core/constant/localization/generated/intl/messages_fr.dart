// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(attemptNumber) =>
      "Je n\'ai pas réussi à deviner le mot en ${attemptNumber} essais.";

  static String m1(attemptNumber) =>
      "Le mot est deviné en ${attemptNumber}/6 essais.";

  static String m2(number) => "Niveau ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("À propos"),
    "appDictionary": MessageLookupByLibrary.simpleMessage(
      "Dictionnaire de l\'application",
    ),
    "appLanguage": MessageLookupByLibrary.simpleMessage(
      "Langue de l\'application",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Lexora"),
    "casual": MessageLookupByLibrary.simpleMessage("Par défaut"),
    "checkResult": MessageLookupByLibrary.simpleMessage(
      "Vérifiez votre résultat ici :",
    ),
    "checkResultLose": m0,
    "checkResultWin": m1,
    "colorMode": MessageLookupByLibrary.simpleMessage("Mode de couleur"),
    "contact": MessageLookupByLibrary.simpleMessage(
      "Si vous ne trouvez pas un mot dans le dictionnaire\nou s\'il a une mauvaise définition,\nécrivez-nous, nous l\'ajouterons\ndans la prochaine mise à jour.\n",
    ),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Série\nactuelle"),
    "daily": MessageLookupByLibrary.simpleMessage("Quotidien"),
    "en": MessageLookupByLibrary.simpleMessage("Anglais"),
    "examples": MessageLookupByLibrary.simpleMessage("Exemples"),
    "guessDistribution": MessageLookupByLibrary.simpleMessage(
      "Répartition des essais",
    ),
    "highContrast": MessageLookupByLibrary.simpleMessage("Contraste élevé"),
    "levelNumber": m2,
    "levels": MessageLookupByLibrary.simpleMessage("Niveaux"),
    "loseMessage": MessageLookupByLibrary.simpleMessage("Vous avez perdu"),
    "maxStreak": MessageLookupByLibrary.simpleMessage("Série\nmaximale"),
    "newWordAvailableEachDay": MessageLookupByLibrary.simpleMessage(
      "Un nouveau mot sera disponible chaque jour !",
    ),
    "nextLevel": MessageLookupByLibrary.simpleMessage("Niveau suivant"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Prochain mot dans"),
    "notPlayed": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas encore joué",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Autre"),
    "played": MessageLookupByLibrary.simpleMessage("Parties jouées"),
    "progressSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de sauvegarder la progression. Votre grille reste disponible.",
    ),
    "resultUnavailable": MessageLookupByLibrary.simpleMessage(
      "Résultat indisponible",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "fon": MessageLookupByLibrary.simpleMessage("Fon"),
    "fr": MessageLookupByLibrary.simpleMessage("Français"),
    "ru": MessageLookupByLibrary.simpleMessage("Russe"),
    "secretWord": MessageLookupByLibrary.simpleMessage("Mot secret"),
    "sendMessage": MessageLookupByLibrary.simpleMessage(
      "subject=Lexora%20-%20Nouveau%20mot&body=Mot%20-%0ASignification%20-",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "share": MessageLookupByLibrary.simpleMessage("Partager"),
    "start": MessageLookupByLibrary.simpleMessage("Commencer la partie"),
    "statistic": MessageLookupByLibrary.simpleMessage("Statistiques"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Sombre"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Clair"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Thème"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("Système"),
    "tutorial": MessageLookupByLibrary.simpleMessage("Comment jouer"),
    "tutorialDescription1": MessageLookupByLibrary.simpleMessage(
      "Chaque essai doit être un mot valide de 5 lettres. Appuyez sur Entrée pour valider.",
    ),
    "tutorialDescription2": MessageLookupByLibrary.simpleMessage(
      "Après chaque essai, la couleur des cases change pour indiquer à quel point votre essai est proche du mot.",
    ),
    "tutorialNotInWordSpot": MessageLookupByLibrary.simpleMessage(
      "La lettre E n\'est pas dans le mot, où que ce soit.",
    ),
    "tutorialTitle": MessageLookupByLibrary.simpleMessage(
      "Devinez le MOT en 6 essais.",
    ),
    "tutorialWordCorrectSpot": MessageLookupByLibrary.simpleMessage(
      "La lettre P est dans le mot et à la bonne place.",
    ),
    "tutorialWordWrongSpot": MessageLookupByLibrary.simpleMessage(
      "La lettre A est dans le mot mais à la mauvaise place.",
    ),
    "viewLevels": MessageLookupByLibrary.simpleMessage("Voir les niveaux"),
    "viewStatistic": MessageLookupByLibrary.simpleMessage(
      "Voir les statistiques",
    ),
    "winMessage": MessageLookupByLibrary.simpleMessage("Vous avez gagné !"),
    "winRate": MessageLookupByLibrary.simpleMessage("Taux\nde victoire"),
    "wordNotFound": MessageLookupByLibrary.simpleMessage(
      "Mot introuvable dans le dictionnaire",
    ),
    "wordTooShort": MessageLookupByLibrary.simpleMessage(
      "Le mot n\'a pas la bonne longueur",
    ),
    "achFiftyLevels": MessageLookupByLibrary.simpleMessage(
      "50 niveaux",
    ),
    "achFiftyLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Termine 50 niveaux",
    ),
    "achFirstWin": MessageLookupByLibrary.simpleMessage(
      "Première victoire",
    ),
    "achFirstWinDesc": MessageLookupByLibrary.simpleMessage(
      "Remporte ta première partie",
    ),
    "achFiveWins": MessageLookupByLibrary.simpleMessage(
      "5 victoires",
    ),
    "achFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Gagne 5 parties",
    ),
    "achHintUser": MessageLookupByLibrary.simpleMessage(
      "Maître des indices",
    ),
    "achHintUserDesc": MessageLookupByLibrary.simpleMessage(
      "Utilise un indice 3 fois",
    ),
    "achRich": MessageLookupByLibrary.simpleMessage(
      "Trésor",
    ),
    "achRichDesc": MessageLookupByLibrary.simpleMessage(
      "Détenir 500 jetons",
    ),
    "achStreak3": MessageLookupByLibrary.simpleMessage(
      "Série de 3 victoires",
    ),
    "achStreak3Desc": MessageLookupByLibrary.simpleMessage(
      "Gagne 3 parties quotidiennes d’affilée",
    ),
    "achStreak7": MessageLookupByLibrary.simpleMessage(
      "Série de 7 victoires",
    ),
    "achStreak7Desc": MessageLookupByLibrary.simpleMessage(
      "Gagne 7 parties quotidiennes d’affilée",
    ),
    "achTenLevels": MessageLookupByLibrary.simpleMessage(
      "10 niveaux",
    ),
    "achTenLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Termine 10 niveaux",
    ),
    "achTwentyFiveWins": MessageLookupByLibrary.simpleMessage(
      "25 victoires",
    ),
    "achTwentyFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Gagne 25 parties",
    ),
    "achievements": MessageLookupByLibrary.simpleMessage(
      "Succès",
    ),
    "achievementsLocked": MessageLookupByLibrary.simpleMessage(
      "Verrouillé",
    ),
    "achievementsUnlocked": MessageLookupByLibrary.simpleMessage(
      "Succès débloqué !",
    ),
    "balance": MessageLookupByLibrary.simpleMessage(
      "Solde",
    ),
    "challengeCompleted": MessageLookupByLibrary.simpleMessage(
      "Défi relevé !",
    ),
    "challengeReward": MessageLookupByLibrary.simpleMessage(
      "Récompense",
    ),
    "dailyChallengeFast": MessageLookupByLibrary.simpleMessage(
      "Gagner en 4 essais ou moins",
    ),
    "dailyChallengeStreak": MessageLookupByLibrary.simpleMessage(
      "Gagner 3 parties quotidiennes d’affilée",
    ),
    "dailyChallengeWord": MessageLookupByLibrary.simpleMessage(
      "Terminer le mot du jour",
    ),
    "dailyChallenges": MessageLookupByLibrary.simpleMessage(
      "Défis du jour",
    ),
    "earnTip": MessageLookupByLibrary.simpleMessage(
      "Gagne des parties pour gagner des jetons et de l’XP !",
    ),
    "eliminateLetters": MessageLookupByLibrary.simpleMessage(
      "Éliminer des lettres",
    ),
    "hintShop": MessageLookupByLibrary.simpleMessage(
      "Boutique d’indices",
    ),
    "hints": MessageLookupByLibrary.simpleMessage(
      "Indices",
    ),
    "levelUpMessage": MessageLookupByLibrary.simpleMessage(
      "Vous avez atteint un nouveau niveau",
    ),
    "levelUpTitle": MessageLookupByLibrary.simpleMessage(
      "Niveau supérieur !",
    ),
    "notEnoughTokens": MessageLookupByLibrary.simpleMessage(
      "Pas assez de jetons",
    ),
    "playerLevel": MessageLookupByLibrary.simpleMessage(
      "Niveau du joueur",
    ),
    "profile": MessageLookupByLibrary.simpleMessage(
      "Profil",
    ),
    "revealLetter": MessageLookupByLibrary.simpleMessage(
      "Révéler une lettre",
    ),
    "rowIsFullFirst": MessageLookupByLibrary.simpleMessage(
      "Complète d’abord le mot en cours",
    ),
    "sound": MessageLookupByLibrary.simpleMessage(
      "Effets sonores",
    ),
    "tokens": MessageLookupByLibrary.simpleMessage(
      "Jetons",
    ),
    "vibration": MessageLookupByLibrary.simpleMessage(
      "Vibrations",
    ),
    "xp": MessageLookupByLibrary.simpleMessage(
      "XP",
    ),
    "avatarApplied": MessageLookupByLibrary.simpleMessage(
      "Avatar sélectionné",
    ),
    "avatarFox": MessageLookupByLibrary.simpleMessage(
      "Renard",
    ),
    "avatarOwl": MessageLookupByLibrary.simpleMessage(
      "Chouette",
    ),
    "avatarTiger": MessageLookupByLibrary.simpleMessage(
      "Tigre",
    ),
    "chestOpen": MessageLookupByLibrary.simpleMessage(
      "Ouvrir",
    ),
    "chestReward": MessageLookupByLibrary.simpleMessage(
      "Trésor ouvert !",
    ),
    "chestTitle": MessageLookupByLibrary.simpleMessage(
      "Trésor quotidien",
    ),
    "chestTomorrow": MessageLookupByLibrary.simpleMessage(
      "Reviens demain",
    ),
    "itemActive": MessageLookupByLibrary.simpleMessage(
      "Actif",
    ),
    "itemBuy": MessageLookupByLibrary.simpleMessage(
      "Acheter",
    ),
    "itemOwned": MessageLookupByLibrary.simpleMessage(
      "Possédé",
    ),
    "league": MessageLookupByLibrary.simpleMessage(
      "Ligue",
    ),
    "leagueBronze": MessageLookupByLibrary.simpleMessage(
      "Bronze",
    ),
    "leagueBronzeNext": MessageLookupByLibrary.simpleMessage(
      "Palier suivant à 100 XP",
    ),
    "leagueClaim": MessageLookupByLibrary.simpleMessage(
      "Réclamer le bonus",
    ),
    "leagueClaimed": MessageLookupByLibrary.simpleMessage(
      "Réclamé",
    ),
    "leagueDiamond": MessageLookupByLibrary.simpleMessage(
      "Diamant",
    ),
    "leagueDiamondNext": MessageLookupByLibrary.simpleMessage(
      "Palier maximum !",
    ),
    "leagueGold": MessageLookupByLibrary.simpleMessage(
      "Or",
    ),
    "leagueGoldNext": MessageLookupByLibrary.simpleMessage(
      "Palier suivant à 500 XP",
    ),
    "leagueNoPrevious": MessageLookupByLibrary.simpleMessage(
      "Aucun XP la semaine dernière",
    ),
    "leaguePerLanguage": MessageLookupByLibrary.simpleMessage(
      "XP hebdo par langue",
    ),
    "leaguePrevious": MessageLookupByLibrary.simpleMessage(
      "Semaine dernière",
    ),
    "leagueReward": MessageLookupByLibrary.simpleMessage(
      "Bonus",
    ),
    "leagueSilver": MessageLookupByLibrary.simpleMessage(
      "Argent",
    ),
    "leagueSilverNext": MessageLookupByLibrary.simpleMessage(
      "Palier suivant à 250 XP",
    ),
    "leagueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gagne de l’XP chaque semaine et réclame des bonus",
    ),
    "leagueThisWeek": MessageLookupByLibrary.simpleMessage(
      "Cette semaine",
    ),
    "leagueTier": MessageLookupByLibrary.simpleMessage(
      "Palier",
    ),
    "shop": MessageLookupByLibrary.simpleMessage(
      "Boutique",
    ),
    "shopAvatars": MessageLookupByLibrary.simpleMessage(
      "Avatars",
    ),
    "shopBought": MessageLookupByLibrary.simpleMessage(
      "Article acheté !",
    ),
    "shopSubtitle": MessageLookupByLibrary.simpleMessage(
      "Dépense des jetons pour des thèmes et avatars",
    ),
    "shopThemes": MessageLookupByLibrary.simpleMessage(
      "Thèmes",
    ),
    "themeApplied": MessageLookupByLibrary.simpleMessage(
      "Thème appliqué",
    ),
    "themeForest": MessageLookupByLibrary.simpleMessage(
      "Forêt",
    ),
    "themeMidnight": MessageLookupByLibrary.simpleMessage(
      "Minuit",
    ),
    "themeOcean": MessageLookupByLibrary.simpleMessage(
      "Océan",
    ),
    "themeRoyal": MessageLookupByLibrary.simpleMessage(
      "Royal",
    ),
    "themeSunset": MessageLookupByLibrary.simpleMessage(
      "Coucher de soleil",
    ),
  };
}
