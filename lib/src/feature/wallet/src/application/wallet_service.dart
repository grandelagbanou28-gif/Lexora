import 'package:flutter/foundation.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/achievement.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/daily_challenge.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/game_reward.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/wallet_state.dart';
import 'package:wordly/src/feature/wallet/src/domain/repositories/wallet_repository.dart';

final class WalletService({required final WalletRepository _repository}) {
  final ValueNotifier<WalletState> _notifier = ValueNotifier<WalletState>(const WalletState());
  WalletState _current = const WalletState();

  static Future<WalletService> create({required WalletRepository repository}) async {
    final service = WalletService(repository: repository);
    final WalletState initial = await repository.read();
    service
      .._current = initial
      .._notifier.value = initial;
    return service;
  }

  ValueNotifier<WalletState> get notifier => _notifier;

  WalletState get current => _current;

  Future<bool> spendTokens(int amount) {
    if (_current.tokens < amount) {
      return Future.value(false);
    }
    return _update(_current.copyWith(tokens: _current.tokens - amount));
  }

  Future<bool> useHint(int amount) {
    if (_current.tokens < amount) {
      return Future.value(false);
    }
    return _update(_current.copyWith(tokens: _current.tokens - amount, hintsUsed: _current.hintsUsed + 1));
  }

  Future<bool> purchaseItem(String itemId, int price) {
    if (_current.tokens < price || _current.ownedItems.contains(itemId)) {
      return Future.value(false);
    }
    return _update(_current.copyWith(tokens: _current.tokens - price, ownedItems: [..._current.ownedItems, itemId]));
  }

  Future<bool> setActiveAvatar(String avatarId) {
    if (!_current.ownedItems.contains(avatarId)) {
      return Future.value(false);
    }
    return _update(_current.copyWith(activeAvatar: avatarId));
  }

  Future<int> claimDailyChest(DateTime now) async {
    final String key = _dateKey(now);
    if (_current.lastChestDateKey == key) {
      return 0;
    }
    final int reward = 5 + _stableHash(key) % 21;
    await _update(_current.copyWith(tokens: _current.tokens + reward, lastChestDateKey: key));
    return reward;
  }

  Future<int> claimLeagueBonus(String dictionary, DateTime now) async {
    final previousKey = '$dictionary|${leagueWeekKey(now.subtract(const Duration(days: 7)))}';
    final int previous = _current.weeklyXp[previousKey] ?? 0;
    if (previous < 1 || _current.leagueBonusClaimed.contains(previousKey)) {
      return 0;
    }
    final int bonus = leagueBonusFor(previous);
    await _update(
      _current.copyWith(xp: _current.xp + bonus, leagueBonusClaimed: [..._current.leagueBonusClaimed, previousKey]),
    );
    return bonus;
  }

  Future<GameReward> processGameResult({
    required GameMode mode,
    required bool isWin,
    required int attempt,
    required DateTime now,
    required String dictionary,
  }) async {
    final WalletState previous = _current;
    final String key = _dateKey(now);

    int tokens = previous.tokens;
    final int totalGames = previous.totalGames + 1;
    int totalWins = previous.totalWins;
    int levelsCompleted = previous.levelsCompleted;
    int currentStreak = previous.currentStreak;
    int maxStreak = previous.maxStreak;
    String? lastGameDateKey = previous.lastGameDateKey;
    final int xp = previous.xp;

    var tokenDelta = 0;
    var xpDelta = 0;
    if (isWin) {
      totalWins++;
    }
    switch (mode) {
      case GameMode.daily:
        if (isWin) {
          tokenDelta = 25;
          xpDelta = 60;
          if (_isPreviousDay(lastGameDateKey, key)) {
            currentStreak += 1;
          } else if (lastGameDateKey != key) {
            currentStreak = 1;
          }
          lastGameDateKey = key;
          if (currentStreak > maxStreak) {
            maxStreak = currentStreak;
          }
        } else {
          tokenDelta = 5;
          xpDelta = 10;
          if (lastGameDateKey != key) {
            currentStreak = 0;
          }
          lastGameDateKey = key;
        }
      case GameMode.lvl:
        tokenDelta = isWin ? 15 : 2;
        xpDelta = isWin ? 40 : 5;
        if (isWin) {
          levelsCompleted++;
        }
    }

    tokens += tokenDelta;
    final int updatedXp = xp + xpDelta;
    final int previousLevel = previous.playerLevel;
    final bool leveledUp = (1 + updatedXp ~/ WalletState.xpPerLevel) > previousLevel;

    final List<Achievement> unlocked = [];
    final List<String> unlockedIds = List.of(previous.unlockedAchievements);
    final WalletState beforeRewards = previous.copyWith(
      tokens: tokens,
      xp: updatedXp,
      totalGames: totalGames,
      totalWins: totalWins,
      levelsCompleted: levelsCompleted,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      lastGameDateKey: lastGameDateKey,
    );
    for (final Achievement achievement in AchievementsCatalog.all) {
      if (!unlockedIds.contains(achievement.id.name) && achievement.isUnlocked(beforeRewards)) {
        unlocked.add(achievement);
        unlockedIds.add(achievement.id.name);
        tokens += achievement.tokenReward;
      }
    }

    Map<String, List<String>> dailyChallenges = previous.dailyChallenges;
    final List<DailyChallenge> completed = [];
    if (mode == GameMode.daily) {
      final List<String> done = List.of(dailyChallenges[key] ?? const []);
      for (final DailyChallenge challenge in DailyChallengesCatalog.all) {
        if (done.contains(challenge.id.name)) {
          continue;
        }
        final bool completedNow = switch (challenge.id) {
          DailyChallengeId.word => true,
          DailyChallengeId.fast => isWin && attempt <= 4,
          DailyChallengeId.streak => currentStreak >= 3,
        };
        if (completedNow) {
          done.add(challenge.id.name);
          completed.add(challenge);
          tokens += challenge.reward;
        }
      }
      done.sort();
      dailyChallenges = Map.of(dailyChallenges)..[key] = List.of(done);
    }

    final leagueKey = '$dictionary|${leagueWeekKey(now)}';
    final Map<String, int> weeklyXp = Map.of(previous.weeklyXp)
      ..[leagueKey] = (previous.weeklyXp[leagueKey] ?? 0) + xpDelta;

    final WalletState wallet = beforeRewards.copyWith(
      tokens: tokens,
      xp: updatedXp,
      unlockedAchievements: unlockedIds..sort(),
      dailyChallenges: dailyChallenges,
      weeklyXp: weeklyXp,
    );
    await _update(wallet);
    return GameReward(
      wallet: wallet,
      tokenDelta: tokenDelta,
      xpDelta: xpDelta,
      leveledUp: leveledUp,
      achievements: unlocked,
      challenges: completed,
    );
  }

  Future<bool> _update(WalletState wallet) async {
    _current = wallet;
    _notifier.value = wallet;
    await _repository.save(wallet);
    return true;
  }
}

String _dateKey(DateTime now) => '${now.year}-${_pad(now.month)}-${_pad(now.day)}';

String _pad(int value) => value.toString().padLeft(2, '0');

bool _isPreviousDay(String? last, String key) {
  if (last == null) {
    return false;
  }
  final List<int> lastParts = last.split('-').map(int.parse).toList(growable: false);
  final List<int> keyParts = key.split('-').map(int.parse).toList(growable: false);
  final lastDate = DateTime.utc(lastParts[0], lastParts[1], lastParts[2]);
  final keyDate = DateTime.utc(keyParts[0], keyParts[1], keyParts[2]);
  return keyDate.difference(lastDate).inDays == 1;
}

/// Stable non-negative hash used to derive a deterministic chest reward.
int _stableHash(String value) {
  var hash = 0;
  for (final int unit in value.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return hash;
}

String leagueWeekKey(DateTime now) {
  return '${now.year}-W${_weekOfYear(now).toString().padLeft(2, '0')}';
}

int _weekOfYear(DateTime date) {
  final int dayOfWeek = date.weekday;
  final int dayOfYear = DateTime.utc(date.year, date.month, date.day).difference(DateTime.utc(date.year)).inDays + 1;
  final int week = (dayOfYear - dayOfWeek + 10) ~/ 7;
  if (week < 1) {
    return _weekOfYear(DateTime.utc(date.year - 1, 12, 28));
  }
  if (week > 52 && DateTime.utc(date.year, 12, 31).weekday < 4) {
    return 1;
  }
  return week;
}

/// League tier: 1 = bronze, 2 = silver, 3 = gold, 4 = diamond.
int leagueXpTier(int xp) => xp < 100
    ? 1
    : xp < 250
    ? 2
    : xp < 500
    ? 3
    : 4;

/// Weekly league bonus rewarded for a finished week at [xp].
int leagueBonusFor(int xp) => leagueXpTier(xp) * 20;
