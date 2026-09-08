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
    'shop': ('Shop', 'Boutique', 'Xwégbé', 'Магазин'),
    'shopSubtitle': (
        'Spend tokens on themes and avatars',
        'Dépense des jetons pour des thèmes et avatars',
        'Zán kúntó ná ɖé kpó avata kpó',
        'Трать монеты на темы и аватары',
    ),
    'shopThemes': ('Themes', 'Thèmes', 'Ɖé lɛ', 'Темы'),
    'shopAvatars': ('Avatars', 'Avatars', 'Avata lɛ', 'Аватары'),
    'themeOcean': ('Ocean', 'Océan', 'Atlan', 'Океан'),
    'themeForest': ('Forest', 'Forêt', 'Gbɛ́zìn', 'Лес'),
    'themeSunset': ('Sunset', 'Coucher de soleil', 'Hwlɛvínyínyí', 'Закат'),
    'themeMidnight': ('Midnight', 'Minuit', 'Zǎngbɛ', 'Полночь'),
    'themeRoyal': ('Royal', 'Royal', 'Xwétɔ́', 'Королевский'),
    'avatarFox': ('Fox', 'Renard', 'Wɛcèní', 'Лиса'),
    'avatarTiger': ('Tiger', 'Tigre', 'Tigrí', 'Тигр'),
    'avatarOwl': ('Owl', 'Chouette', 'Xlèxlu', 'Сова'),
    'itemOwned': ('Owned', 'Possédé', 'Ɖe nà', 'Куплено'),
    'itemActive': ('Active', 'Actif', 'E nyí zínzín', 'Активно'),
    'itemBuy': ('Buy', 'Acheter', 'Xɔ́', 'Купить'),
    'shopBought': ('Item purchased!', 'Article acheté !', 'Nú dídó xɔ́!', 'Товар куплен!'),
    'themeApplied': ('Theme applied', 'Thème appliqué', 'Ɖé xón dó', 'Тема применена'),
    'avatarApplied': ('Avatar selected', 'Avatar sélectionné', 'Avata xón dó', 'Аватар выбран'),
    'chestTitle': ('Daily treasure', 'Trésor quotidien', 'Akwe azǎn ɖokpo', 'Ежедневное сокровище'),
    'chestOpen': ('Open', 'Ouvrir', 'Hùn', 'Открыть'),
    'chestTomorrow': ('Come back tomorrow', 'Reviens demain', 'Gbɔ̀ ɖò sɔ̀', 'Вернись завтра'),
    'chestReward': ('Treasure opened!', 'Trésor ouvert !', 'Akwe hùn!', 'Сокровище открыто!'),
    'league': ('League', 'Ligue', 'Xwéta', 'Лига'),
    'leagueSubtitle': (
        'Earn XP every week and claim bonuses',
        'Gagne de l\u2019XP chaque semaine et réclame des bonus',
        'Zán XP sɛ́nsɛ́n ɔ dó xɔ́ bonus',
        'Зарабатывай опыт каждую неделю и получай бонусы',
    ),
    'leagueThisWeek': ('This week', 'Cette semaine', 'Sɛ́nsɛ́n e ɔ', 'Эта неделя'),
    'leagueTier': ('Tier', 'Palier', 'Xwá', 'Дивизион'),
    'leagueBronze': ('Bronze', 'Bronze', 'Avala', 'Бронза'),
    'leagueSilver': ('Silver', 'Argent', 'Klúsó', 'Серебро'),
    'leagueGold': ('Gold', 'Or', 'Sáxlu', 'Золото'),
    'leagueDiamond': ('Diamond', 'Diamant', 'Kplándén', 'Алмаз'),
    'leaguePerLanguage': (
        'Weekly XP per language',
        'XP hebdo par langue',
        'XP sɛ́nsɛ́n dó gbɛ̀mé ɖokpo',
        'Недельный опыт по языкам',
    ),
    'leaguePrevious': ('Last week', 'Semaine dernière', 'Sɛ́nsɛ́n xó', 'Прошлая неделя'),
    'leagueClaim': ('Claim bonus', 'Réclamer le bonus', 'Xɔ́ bonus', 'Получить бонус'),
    'leagueClaimed': ('Claimed', 'Réclamé', 'Xɔ́ kpó', 'Получено'),
    'leagueNoPrevious': ('No XP last week', 'Aucun XP la semaine dernière', 'XP ma ɖó sɛ́nsɛ́n xó', 'За прошлую неделю опыта нет'),
    'leagueReward': ('Bonus', 'Bonus', 'Bonus', 'Бонус'),
    'leagueBronzeNext': ('Tier up at 100 XP', 'Palier suivant à 100 XP', 'Xwá vɔ́vɔ́ ɖò XP 100', 'Следующий дивизион на 100 XP'),
    'leagueSilverNext': ('Tier up at 250 XP', 'Palier suivant à 250 XP', 'Xwá vɔ́vɔ́ ɖò XP 250', 'Следующий дивизион на 250 XP'),
    'leagueGoldNext': ('Tier up at 500 XP', 'Palier suivant à 500 XP', 'Xwá vɔ́vɔ́ ɖò XP 500', 'Следующий дивизион на 500 XP'),
    'leagueDiamondNext': ('Top tier!', 'Palier maximum !', 'Xwá daxó!', 'Максимальный дивизион!'),
}

_sorted_keys = sorted(STRINGS)
_messages_cache: dict[str, str] = {}


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
        if f'    "{key}":' not in _messages_cache[locale]:
            value = STRINGS[key][LOCALES.index(locale)]
            escaped = _dart_double_escape(value)
            lines.append(f'    "{key}": MessageLookupByLibrary.simpleMessage(\n      "{escaped}",\n    ),')
    return '\n'.join(lines)


def _l10n_getters_snippet(content, anchor_offset):
    lines = []
    for key in _sorted_keys:
        marker = f'  String get {key} {{'
        if marker in content[:anchor_offset]:
            continue
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
    # messages_*.dart: insert missing keys right before the closing "};" of the map.
    for locale in LOCALES:
        path = os.path.join(GEN, 'intl', f'messages_{locale}.dart')
        with open(path, encoding='utf-8') as f:
            _messages_cache[locale] = f.read()
        snippet = _messages_snippet(locale)
        if snippet:
            marker = '  };'
            idx = _messages_cache[locale].rfind(marker)
            assert idx != -1, f'no map close in {path}'
            new_content = _messages_cache[locale][:idx] + snippet + '\n' + _messages_cache[locale][idx:]
            with open(path, 'w', encoding='utf-8', newline='') as f:
                f.write(new_content)
            print(f'updated {os.path.basename(path)}')
        else:
            print(f'{os.path.basename(path)}: up to date')

    # l10n.dart: insert missing getters right before the final class closing brace.
    path = os.path.join(GEN, 'l10n.dart')
    with open(path, encoding='utf-8') as f:
        content = f.read()
    anchor = 'class AppLocalizationDelegate'
    a = content.index(anchor)
    snippet = _l10n_getters_snippet(content, a)
    if snippet:
        pre = content[:a]
        lb = pre.rindex('}')
        new_content = pre[:lb] + '\n' + snippet + pre[lb:] + content[a:]
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(new_content)
        print('updated l10n.dart')
    else:
        print('l10n.dart: up to date')


def main():
    _update_arbs()
    _update_generated_dart()


if __name__ == '__main__':
    main()