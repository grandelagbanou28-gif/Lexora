"""Deterministic l10n updater for Lexora.

Keeps the ARB files and the already-committed Localizely-style generated Dart
files (l10n.dart + intl/messages_*.dart) in sync. New strings are defined in
STRINGS below as (en, fr, fon, ru). Run:  python tool/update_l10n.py
"""

import json
import os

BASE = os.path.join(os.path.dirname(__file__), '..', 'lib', 'src', 'core', 'constant', 'localization')
ARB_DIR = os.path.join(BASE, 'translations')
GEN = os.path.join(BASE, 'generated')

LOCALES = ('en', 'fr', 'fon', 'ru')
ARB_FILES = {
    'en': os.path.join(ARB_DIR, 'intl_en.arb'),
    'fr': os.path.join(ARB_DIR, 'intl_fr.arb'),
    'fon': os.path.join(ARB_DIR, 'intl_fon.arb'),
    'ru': os.path.join(ARB_DIR, 'intl_ru.arb'),
}

# key -> (en, fr, fon, ru)
STRINGS = {
    'profile': ('Profile', 'Profil', 'Nù hùnwlán', 'Профиль'),
    'playerLevel': ('Player level', 'Niveau du joueur', 'Détré nú xwlántó', 'Уровень игрока'),
    'xp': ('XP', 'XP', 'XP', 'Опыт'),
    'tokens': ('Tokens', 'Jetons', 'Kúntó', 'Монеты'),
    'balance': ('Balance', 'Solde', 'Fɖe é ɖe', 'Баланс'),
    'earnTip': (
        'Win games to earn tokens and XP!',
        'Gagne des parties pour gagner des jetons et de l\u2019XP !',
        'Xɔ́ azɔ̌ ɔ dó nú kplé kúntó kpó XP kpó!',
        'Выигрывай игры, чтобы получать монеты и опыт!',
    ),
    'hintShop': ('Hint shop', 'Boutique d\u2019indices', 'Xwégbé nú alɔ́dodo', 'Магазин подсказок'),
    'hints': ('Hints', 'Indices', 'Alɔ́dodo lɛ', 'Подсказки'),
    'revealLetter': ('Reveal a letter', 'Révéler une lettre', 'Sɔ́ wɛndagbé ɖé ɖo alɔ́', 'Показать букву'),
    'eliminateLetters': (
        'Eliminate letters',
        'Éliminer des lettres',
        'Súsú wɛndagbé lɛ',
        'Убрать буквы',
    ),
    'notEnoughTokens': (
        'Not enough tokens',
        'Pas assez de jetons',
        'Kúntó ma sú dó',
        'Недостаточно монет',
    ),
    'rowIsFullFirst': (
        'Complete the current word first',
        'Complète d\u2019abord le mot en cours',
        'Bɔ́ wɛn e ɖo tɛǹnɛ ɔ dó hwɛ',
        'Сначала заверши текущее слово',
    ),
    'levelUpTitle': ('Level up!', 'Niveau supérieur !', 'Détré vɔvɔ́!', 'Новый уровень!'),
    'levelUpMessage': (
        'You reached a new level',
        'Vous avez atteint un nouveau niveau',
        'A wɛ détré vɔvɔ́ ɖé jí',
        'Вы достигли нового уровня',
    ),
    'challengeCompleted': (
        'Challenge completed!',
        'Défi relevé !',
        'Azɔ̌ ɔ kpé!',
        'Задание выполнено!',
    ),
    'challengeReward': ('Reward', 'Récompense', 'Fɖé ù', 'Награда'),
    'dailyChallenges': ('Daily challenges', 'Défis du jour', 'Azɔ̌ azǎn ɖokpo lɛ', 'Ежедневные задания'),
    'dailyChallengeWord': (
        'Complete today\u2019s word',
        'Terminer le mot du jour',
        'Bɔ́ azǎn ɔ tɔn wɛn ɔ',
        'Отгадай сегодняшнее слово',
    ),
    'dailyChallengeFast': (
        'Win in 4 tries or less',
        'Gagner en 4 essais ou moins',
        'Xɔ́ ɖò alijɛ 4 mɛ kpɛ́',
        'Победить за 4 попытки или меньше',
    ),
    'dailyChallengeStreak': (
        'Win 3 daily games in a row',
        'Gagner 3 parties quotidiennes d\u2019affilée',
        'Xɔ́ azɔ̌ 3 sɔsɔ́ azǎn ɖokpo',
        'Выиграть 3 ежедневные игры подряд',
    ),
    'achievements': ('Achievements', 'Succès', 'Njijɛ lɛ', 'Достижения'),
    'achievementsUnlocked': (
        'Achievement unlocked!',
        'Succès débloqué !',
        'Njijɛ ɔ hùn!',
        'Достижение открыто!',
    ),
    'achievementsLocked': ('Locked', 'Verrouillé', 'Klú', 'Закрыто'),
    'sound': ('Sound effects', 'Effets sonores', 'Sín bìbù', 'Звуковые эффекты'),
    'vibration': ('Vibration', 'Vibrations', 'Dɔkɔ̀nɔ', 'Вибрация'),
    'achFirstWin': ('First win', 'Première victoire', 'Xɔ́wɛn nukɔntɔn', 'Первая победа'),
    'achFirstWinDesc': (
        'Win your first game',
        'Remporte ta première partie',
        'Xɔ́ aɖo e ɖokpo ɖokpo',
        'Выиграй свою первую игру',
    ),
    'achFiveWins': ('Five wins', '5 victoires', 'Xɔ́wɛn 5', '5 побед'),
    'achFiveWinsDesc': ('Win 5 games', 'Gagne 5 parties', 'Xɔ́ azɔ̌ 5', 'Выиграй 5 игр'),
    'achTwentyFiveWins': ('25 wins', '25 victoires', 'Xɔ́wɛn 25', '25 побед'),
    'achTwentyFiveWinsDesc': ('Win 25 games', 'Gagne 25 parties', 'Xɔ́ azɔ̌ 25', 'Выиграй 25 игр'),
    'achStreak3': ('Streak of 3 wins', 'Série de 3 victoires', 'Série 3', 'Серия из 3 побед'),
    'achStreak3Desc': (
        'Win 3 daily games in a row',
        'Gagne 3 parties quotidiennes d\u2019affilée',
        'Xɔ́ azɔ̌ 3 sɔsɔ́',
        'Выиграй 3 ежедневные игры подряд',
    ),
    'achStreak7': ('Streak of 7 wins', 'Série de 7 victoires', 'Série 7', 'Серия из 7 побед'),
    'achStreak7Desc': (
        'Win 7 daily games in a row',
        'Gagne 7 parties quotidiennes d\u2019affilée',
        'Xɔ́ azɔ̌ 7 sɔsɔ́',
        'Выиграй 7 ежедневных игр подряд',
    ),
    'achTenLevels': ('Ten levels', '10 niveaux', 'Détré 10', '10 уровней'),
    'achTenLevelsDesc': (
        'Complete 10 levels',
        'Termine 10 niveaux',
        'Bɔ́ détré 10',
        'Пройди 10 уровней',
    ),
    'achFiftyLevels': ('Fifty levels', '50 niveaux', 'Détré 50', '50 уровней'),
    'achFiftyLevelsDesc': (
        'Complete 50 levels',
        'Termine 50 niveaux',
        'Bɔ́ détré 50',
        'Пройди 50 уровней',
    ),
    'achRich': ('Treasure', 'Trésor', 'Akwe daxó', 'Сокровище'),
    'achRichDesc': (
        'Hold 500 tokens',
        'Détenir 500 jetons',
        'Kúntó 500 dó alɔ́ mɛ',
        'Накопи 500 монет',
    ),
    'achHintUser': ('Hint master', 'Maître des indices', 'Alɔ́donú daxó', 'Мастер подсказок'),
    'achHintUserDesc': (
        'Use a hint 3 times',
        'Utilise un indice 3 fois',
        'Zǎ alɔ́dodo 3',
        'Используй подсказку 3 раза',
    ),
}

_sorted_keys = sorted(STRINGS)


def _load_arb(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def _save_arb(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def _update_arbs():
    for locale in LOCALES:
        path = ARB_FILES[locale]
        data = _load_arb(path)
        changed = False
        for key in _sorted_keys:
            value = STRINGS[key][LOCALES.index(locale)]
            if key not in data or data[key] != value:
                data[key] = value
                changed = True
        if changed:
            _save_arb(path, data)
            print(f'updated {os.path.basename(path)}')
        else:
            print(f'{os.path.basename(path)}: up to date')


def _dart_double_escape(text):
    return text.replace('\\', '\\\\').replace('"', '\\"').replace('$', '\\$').replace('\n', '\\n')


def _dart_single_escape(text):
    return text.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$').replace('\n', '\\n')


def _messages_snippet(locale):
    lines = []
    for key in _sorted_keys:
        value = STRINGS[key][LOCALES.index(locale)]
        escaped = _dart_double_escape(value)
        lines.append(f'    "{key}": MessageLookupByLibrary.simpleMessage(\n      "{escaped}",\n    ),')
    return '\n'.join(lines)


def _l10n_getters_snippet():
    lines = []
    for key in _sorted_keys:
        en = STRINGS[key][0]
        escaped = _dart_single_escape(en)
        doc = _dart_single_escape(en)
        lines.append(f'  /// `{doc}`')
        lines.append(f'  String get {key} {{')
        lines.append('    return Intl.message(')
        lines.append(f'      \'{escaped}\',')
        lines.append(f'      name: \'{key}\',')
        lines.append("      desc: '',")
        lines.append('      args: [],')
        lines.append('    );')
        lines.append('  }')
        lines.append('')
    return '\n'.join(lines)


def _update_generated_dart():
    # messages_*.dart: insert before the closing "};" of the map.
    for locale in LOCALES:
        path = os.path.join(GEN, 'intl', f'messages_{locale}.dart')
        with open(path, encoding='utf-8') as f:
            content = f.read()
        first_key = _sorted_keys[0]
        if f'    "{first_key}":' in content:
            print(f'{os.path.basename(path)}: up to date')
            continue
        marker = '  };'
        idx = content.rfind(marker)
        assert idx != -1, f'no map close in {path}'
        snippet = _messages_snippet(locale)
        new_content = content[:idx] + snippet + '\n' + content[idx:]
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(new_content)
        print(f'updated {os.path.basename(path)}')

    # l10n.dart: insert getters inside GeneratedLocalizations, right before the
    # final closing brace of the class (the one preceding AppLocalizationDelegate).
    path = os.path.join(GEN, 'l10n.dart')
    with open(path, encoding='utf-8') as f:
        content = f.read()
    anchor = 'class AppLocalizationDelegate'
    a = content.index(anchor)
    first_key = _sorted_keys[0]
    getter_mark = f'  String get {first_key} {{'
    start = content.find(getter_mark, 0, a)
    if start != -1:
        # Already inserted inside the class on a previous run.
        print('l10n.dart: up to date')
        return
    pre = content[:a]
    lb = pre.rindex('}')
    snippet = _l10n_getters_snippet()
    new_content = pre[:lb] + '\n' + snippet + pre[lb:] + content[a:]
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(new_content)
    print('updated l10n.dart')


def main():
    _update_arbs()
    _update_generated_dart()


if __name__ == '__main__':
    main()