// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(attemptNumber) =>
      "У меня не получилось разгадать слово за ${attemptNumber} попыток.";

  static String m1(attemptNumber) =>
      "Я угадал слово за ${attemptNumber}/6 попыток.";

  static String m2(number) => "Уровень ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О приложении"),
    "appDictionary": MessageLookupByLibrary.simpleMessage("Язык словаря"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("Язык приложения"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Lexora"),
    "casual": MessageLookupByLibrary.simpleMessage("Обычный"),
    "checkResult": MessageLookupByLibrary.simpleMessage(
      "Можешь проверить свой результат тут:",
    ),
    "checkResultLose": m0,
    "checkResultWin": m1,
    "colorMode": MessageLookupByLibrary.simpleMessage("Цветовой режим"),
    "contact": MessageLookupByLibrary.simpleMessage(
      "Если вы не нашли слово в словаре\nили оно имеет неправильное определение,\nнапишите нам, мы добавим его\nв следующем обновлении.\n",
    ),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Текущая\nСерия"),
    "daily": MessageLookupByLibrary.simpleMessage("Ежедневный"),
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "examples": MessageLookupByLibrary.simpleMessage("Примеры"),
    "guessDistribution": MessageLookupByLibrary.simpleMessage(
      "Распределение догадок",
    ),
    "highContrast": MessageLookupByLibrary.simpleMessage("Высокий контраст"),
    "levelNumber": m2,
    "levels": MessageLookupByLibrary.simpleMessage("Уровни"),
    "loseMessage": MessageLookupByLibrary.simpleMessage("Вы проиграли"),
    "maxStreak": MessageLookupByLibrary.simpleMessage("Макс.\nСерия"),
    "newWordAvailableEachDay": MessageLookupByLibrary.simpleMessage(
      "Новое слово будет доступно каждый день!",
    ),
    "nextLevel": MessageLookupByLibrary.simpleMessage("Следующий уровень"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Следующее слово через"),
    "notPlayed": MessageLookupByLibrary.simpleMessage(
      "Вы не сыграли ни одной игры",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Другой"),
    "played": MessageLookupByLibrary.simpleMessage("Сыграно"),
    "progressSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сохранить прогресс. Текущая доска не потеряна.",
    ),
    "resultUnavailable": MessageLookupByLibrary.simpleMessage(
      "Результат недоступен",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "fon": MessageLookupByLibrary.simpleMessage("Фон"),
    "fr": MessageLookupByLibrary.simpleMessage("Французский"),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "secretWord": MessageLookupByLibrary.simpleMessage("Загаданное слово"),
    "sendMessage": MessageLookupByLibrary.simpleMessage(
      "subject=Lexora%20-%20Новое%20слово&body=Слово%20-%0AЗначение%20-",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
    "start": MessageLookupByLibrary.simpleMessage("Начать играть"),
    "statistic": MessageLookupByLibrary.simpleMessage("Статистика"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Темная"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Светлая"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("Системная"),
    "tutorial": MessageLookupByLibrary.simpleMessage("Как играть"),
    "tutorialDescription1": MessageLookupByLibrary.simpleMessage(
      "Каждое предположение должно быть словом из 5 букв. Нажмите кнопку ввода, чтобы отправить.",
    ),
    "tutorialDescription2": MessageLookupByLibrary.simpleMessage(
      "После каждого угадывания цвет плиток будет меняться, чтобы показать, насколько близко ваше предположение было к слову.",
    ),
    "tutorialNotInWordSpot": MessageLookupByLibrary.simpleMessage(
      "Буквы А нет в слове ни в одном месте.",
    ),
    "tutorialTitle": MessageLookupByLibrary.simpleMessage(
      "Угадайте СЛОВО за 6 попыток.",
    ),
    "tutorialWordCorrectSpot": MessageLookupByLibrary.simpleMessage(
      "Буква П есть в слове и в нужном месте.",
    ),
    "tutorialWordWrongSpot": MessageLookupByLibrary.simpleMessage(
      "Буква Ш есть в слове, но не в том месте.",
    ),
    "viewLevels": MessageLookupByLibrary.simpleMessage("Посмотреть уровни"),
    "viewStatistic": MessageLookupByLibrary.simpleMessage(
      "Посмотреть статистику",
    ),
    "winMessage": MessageLookupByLibrary.simpleMessage("Вы победили!"),
    "winRate": MessageLookupByLibrary.simpleMessage("Показатель\nпобед"),
    "wordNotFound": MessageLookupByLibrary.simpleMessage(
      "Слово не найдено в словаре",
    ),
    "wordTooShort": MessageLookupByLibrary.simpleMessage(
      "Слово неправильной длины",
    ),
    "achFiftyLevels": MessageLookupByLibrary.simpleMessage(
      "50 уровней",
    ),
    "achFiftyLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Пройди 50 уровней",
    ),
    "achFirstWin": MessageLookupByLibrary.simpleMessage(
      "Первая победа",
    ),
    "achFirstWinDesc": MessageLookupByLibrary.simpleMessage(
      "Выиграй свою первую игру",
    ),
    "achFiveWins": MessageLookupByLibrary.simpleMessage(
      "5 побед",
    ),
    "achFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Выиграй 5 игр",
    ),
    "achHintUser": MessageLookupByLibrary.simpleMessage(
      "Мастер подсказок",
    ),
    "achHintUserDesc": MessageLookupByLibrary.simpleMessage(
      "Используй подсказку 3 раза",
    ),
    "achRich": MessageLookupByLibrary.simpleMessage(
      "Сокровище",
    ),
    "achRichDesc": MessageLookupByLibrary.simpleMessage(
      "Накопи 500 монет",
    ),
    "achStreak3": MessageLookupByLibrary.simpleMessage(
      "Серия из 3 побед",
    ),
    "achStreak3Desc": MessageLookupByLibrary.simpleMessage(
      "Выиграй 3 ежедневные игры подряд",
    ),
    "achStreak7": MessageLookupByLibrary.simpleMessage(
      "Серия из 7 побед",
    ),
    "achStreak7Desc": MessageLookupByLibrary.simpleMessage(
      "Выиграй 7 ежедневных игр подряд",
    ),
    "achTenLevels": MessageLookupByLibrary.simpleMessage(
      "10 уровней",
    ),
    "achTenLevelsDesc": MessageLookupByLibrary.simpleMessage(
      "Пройди 10 уровней",
    ),
    "achTwentyFiveWins": MessageLookupByLibrary.simpleMessage(
      "25 побед",
    ),
    "achTwentyFiveWinsDesc": MessageLookupByLibrary.simpleMessage(
      "Выиграй 25 игр",
    ),
    "achievements": MessageLookupByLibrary.simpleMessage(
      "Достижения",
    ),
    "achievementsLocked": MessageLookupByLibrary.simpleMessage(
      "Закрыто",
    ),
    "achievementsUnlocked": MessageLookupByLibrary.simpleMessage(
      "Достижение открыто!",
    ),
    "balance": MessageLookupByLibrary.simpleMessage(
      "Баланс",
    ),
    "challengeCompleted": MessageLookupByLibrary.simpleMessage(
      "Задание выполнено!",
    ),
    "challengeReward": MessageLookupByLibrary.simpleMessage(
      "Награда",
    ),
    "dailyChallengeFast": MessageLookupByLibrary.simpleMessage(
      "Победить за 4 попытки или меньше",
    ),
    "dailyChallengeStreak": MessageLookupByLibrary.simpleMessage(
      "Выиграть 3 ежедневные игры подряд",
    ),
    "dailyChallengeWord": MessageLookupByLibrary.simpleMessage(
      "Отгадай сегодняшнее слово",
    ),
    "dailyChallenges": MessageLookupByLibrary.simpleMessage(
      "Ежедневные задания",
    ),
    "earnTip": MessageLookupByLibrary.simpleMessage(
      "Выигрывай игры, чтобы получать монеты и опыт!",
    ),
    "eliminateLetters": MessageLookupByLibrary.simpleMessage(
      "Убрать буквы",
    ),
    "hintShop": MessageLookupByLibrary.simpleMessage(
      "Магазин подсказок",
    ),
    "hints": MessageLookupByLibrary.simpleMessage(
      "Подсказки",
    ),
    "levelUpMessage": MessageLookupByLibrary.simpleMessage(
      "Вы достигли нового уровня",
    ),
    "levelUpTitle": MessageLookupByLibrary.simpleMessage(
      "Новый уровень!",
    ),
    "notEnoughTokens": MessageLookupByLibrary.simpleMessage(
      "Недостаточно монет",
    ),
    "playerLevel": MessageLookupByLibrary.simpleMessage(
      "Уровень игрока",
    ),
    "profile": MessageLookupByLibrary.simpleMessage(
      "Профиль",
    ),
    "revealLetter": MessageLookupByLibrary.simpleMessage(
      "Показать букву",
    ),
    "rowIsFullFirst": MessageLookupByLibrary.simpleMessage(
      "Сначала заверши текущее слово",
    ),
    "sound": MessageLookupByLibrary.simpleMessage(
      "Звуковые эффекты",
    ),
    "tokens": MessageLookupByLibrary.simpleMessage(
      "Монеты",
    ),
    "vibration": MessageLookupByLibrary.simpleMessage(
      "Вибрация",
    ),
    "xp": MessageLookupByLibrary.simpleMessage(
      "Опыт",
    ),
    "avatarApplied": MessageLookupByLibrary.simpleMessage(
      "Аватар выбран",
    ),
    "avatarFox": MessageLookupByLibrary.simpleMessage(
      "Лиса",
    ),
    "avatarOwl": MessageLookupByLibrary.simpleMessage(
      "Сова",
    ),
    "avatarTiger": MessageLookupByLibrary.simpleMessage(
      "Тигр",
    ),
    "chestOpen": MessageLookupByLibrary.simpleMessage(
      "Открыть",
    ),
    "chestReward": MessageLookupByLibrary.simpleMessage(
      "Сокровище открыто!",
    ),
    "chestTitle": MessageLookupByLibrary.simpleMessage(
      "Ежедневное сокровище",
    ),
    "chestTomorrow": MessageLookupByLibrary.simpleMessage(
      "Вернись завтра",
    ),
    "itemActive": MessageLookupByLibrary.simpleMessage(
      "Активно",
    ),
    "itemBuy": MessageLookupByLibrary.simpleMessage(
      "Купить",
    ),
    "itemOwned": MessageLookupByLibrary.simpleMessage(
      "Куплено",
    ),
    "league": MessageLookupByLibrary.simpleMessage(
      "Лига",
    ),
    "leagueBronze": MessageLookupByLibrary.simpleMessage(
      "Бронза",
    ),
    "leagueBronzeNext": MessageLookupByLibrary.simpleMessage(
      "Следующий дивизион на 100 XP",
    ),
    "leagueClaim": MessageLookupByLibrary.simpleMessage(
      "Получить бонус",
    ),
    "leagueClaimed": MessageLookupByLibrary.simpleMessage(
      "Получено",
    ),
    "leagueDiamond": MessageLookupByLibrary.simpleMessage(
      "Алмаз",
    ),
    "leagueDiamondNext": MessageLookupByLibrary.simpleMessage(
      "Максимальный дивизион!",
    ),
    "leagueGold": MessageLookupByLibrary.simpleMessage(
      "Золото",
    ),
    "leagueGoldNext": MessageLookupByLibrary.simpleMessage(
      "Следующий дивизион на 500 XP",
    ),
    "leagueNoPrevious": MessageLookupByLibrary.simpleMessage(
      "За прошлую неделю опыта нет",
    ),
    "leaguePerLanguage": MessageLookupByLibrary.simpleMessage(
      "Недельный опыт по языкам",
    ),
    "leaguePrevious": MessageLookupByLibrary.simpleMessage(
      "Прошлая неделя",
    ),
    "leagueReward": MessageLookupByLibrary.simpleMessage(
      "Бонус",
    ),
    "leagueSilver": MessageLookupByLibrary.simpleMessage(
      "Серебро",
    ),
    "leagueSilverNext": MessageLookupByLibrary.simpleMessage(
      "Следующий дивизион на 250 XP",
    ),
    "leagueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Зарабатывай опыт каждую неделю и получай бонусы",
    ),
    "leagueThisWeek": MessageLookupByLibrary.simpleMessage(
      "Эта неделя",
    ),
    "leagueTier": MessageLookupByLibrary.simpleMessage(
      "Дивизион",
    ),
    "shop": MessageLookupByLibrary.simpleMessage(
      "Магазин",
    ),
    "shopAvatars": MessageLookupByLibrary.simpleMessage(
      "Аватары",
    ),
    "shopBought": MessageLookupByLibrary.simpleMessage(
      "Товар куплен!",
    ),
    "shopSubtitle": MessageLookupByLibrary.simpleMessage(
      "Трать монеты на темы и аватары",
    ),
    "shopThemes": MessageLookupByLibrary.simpleMessage(
      "Темы",
    ),
    "themeApplied": MessageLookupByLibrary.simpleMessage(
      "Тема применена",
    ),
    "themeForest": MessageLookupByLibrary.simpleMessage(
      "Лес",
    ),
    "themeMidnight": MessageLookupByLibrary.simpleMessage(
      "Полночь",
    ),
    "themeOcean": MessageLookupByLibrary.simpleMessage(
      "Океан",
    ),
    "themeRoyal": MessageLookupByLibrary.simpleMessage(
      "Королевский",
    ),
    "themeSunset": MessageLookupByLibrary.simpleMessage(
      "Закат",
    ),
    "bossBonus": MessageLookupByLibrary.simpleMessage(
      "Бонус босса",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage(
      "Отмена",
    ),
    "dailyChallengeEcoWin": MessageLookupByLibrary.simpleMessage(
      "Победить без удаления букв",
    ),
    "dailyChallengeNoHint": MessageLookupByLibrary.simpleMessage(
      "Победить без подсказок",
    ),
    "friendMode": MessageLookupByLibrary.simpleMessage(
      "Вызов друга",
    ),
    "hardMode": MessageLookupByLibrary.simpleMessage(
      "Сложный режим",
    ),
    "hardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Без подсказок, больше опыта",
    ),
    "peekRow": MessageLookupByLibrary.simpleMessage(
      "Открыть всю строку",
    ),
    "playAgain": MessageLookupByLibrary.simpleMessage(
      "Сыграть снова",
    ),
    "practiceMode": MessageLookupByLibrary.simpleMessage(
      "Тренировка",
    ),
    "repairStreak": MessageLookupByLibrary.simpleMessage(
      "Восстановить серию",
    ),
    "repairStreakDone": MessageLookupByLibrary.simpleMessage(
      "Серия восстановлена!",
    ),
    "seasonPass": MessageLookupByLibrary.simpleMessage(
      "Недельный абонемент",
    ),
    "seasonPassBought": MessageLookupByLibrary.simpleMessage(
      "Абонемент активирован!",
    ),
    "seasonPassClaim": MessageLookupByLibrary.simpleMessage(
      "Забрать награду дня",
    ),
    "seasonPassDaily": MessageLookupByLibrary.simpleMessage(
      "День",
    ),
    "seasonPassFinished": MessageLookupByLibrary.simpleMessage(
      "Абонемент завершён",
    ),
    "seasonPassSubtitle": MessageLookupByLibrary.simpleMessage(
      "Награда каждый день в течение 7 дней",
    ),
  };
}
