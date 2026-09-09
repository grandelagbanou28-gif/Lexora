import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';

@immutable
final class const WalletState({
  final int tokens = 0,
  final int xp = 0,
  final int totalGames = 0,
  final int totalWins = 0,
  final int levelsCompleted = 0,
  final int hintsUsed = 0,
  final int currentStreak = 0,
  final int maxStreak = 0,
  final String? lastGameDateKey,
  final List<String> unlockedAchievements = const [],
  final Map<String, List<String>> dailyChallenges = const {},
  final List<String> ownedItems = const [],
  final String? activeAvatar,
  final String? lastChestDateKey,
  final Map<String, int> weeklyXp = const {},
  final List<String> leagueBonusClaimed = const [],
  final Map<String, int> revealsPerDay = const {},
  final Map<String, int> eliminatesPerDay = const {},
  final bool seasonPassActive = false,
  final String? seasonPassStartKey,
  final List<int> seasonPassClaimedDays = const [],
}) {
  static const int xpPerLevel = 100;

  int get playerLevel => 1 + xp ~/ xpPerLevel;

  int get levelProgress => xp % xpPerLevel;

  int get seasonPassDayIndex => seasonPassStartKey == null ? -1 : _dateKeyDiff(seasonPassStartKey!, DateTime.now());

  int seasonPassDayIndexAt(DateTime now) => seasonPassStartKey == null ? -1 : _dateKeyDiff(seasonPassStartKey!, now);

  bool get seasonPassFinished => seasonPassActive && seasonPassDayIndex >= 7;

  WalletState copyWith({
    int? tokens,
    int? xp,
    int? totalGames,
    int? totalWins,
    int? levelsCompleted,
    int? hintsUsed,
    int? currentStreak,
    int? maxStreak,
    String? lastGameDateKey,
    List<String>? unlockedAchievements,
    Map<String, List<String>>? dailyChallenges,
    List<String>? ownedItems,
    String? activeAvatar,
    String? lastChestDateKey,
    Map<String, int>? weeklyXp,
    List<String>? leagueBonusClaimed,
    Map<String, int>? revealsPerDay,
    Map<String, int>? eliminatesPerDay,
    bool? seasonPassActive,
    String? seasonPassStartKey,
    List<int>? seasonPassClaimedDays,
  }) => WalletState(
    tokens: tokens ?? this.tokens,
    xp: xp ?? this.xp,
    totalGames: totalGames ?? this.totalGames,
    totalWins: totalWins ?? this.totalWins,
    levelsCompleted: levelsCompleted ?? this.levelsCompleted,
    hintsUsed: hintsUsed ?? this.hintsUsed,
    currentStreak: currentStreak ?? this.currentStreak,
    maxStreak: maxStreak ?? this.maxStreak,
    lastGameDateKey: lastGameDateKey ?? this.lastGameDateKey,
    unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    dailyChallenges: dailyChallenges ?? this.dailyChallenges,
    ownedItems: ownedItems ?? this.ownedItems,
    activeAvatar: activeAvatar ?? this.activeAvatar,
    lastChestDateKey: lastChestDateKey ?? this.lastChestDateKey,
    weeklyXp: weeklyXp ?? this.weeklyXp,
    leagueBonusClaimed: leagueBonusClaimed ?? this.leagueBonusClaimed,
    revealsPerDay: revealsPerDay ?? this.revealsPerDay,
    eliminatesPerDay: eliminatesPerDay ?? this.eliminatesPerDay,
    seasonPassActive: seasonPassActive ?? this.seasonPassActive,
    seasonPassStartKey: seasonPassStartKey ?? this.seasonPassStartKey,
    seasonPassClaimedDays: seasonPassClaimedDays ?? this.seasonPassClaimedDays,
  );
}

int _dateKeyDiff(String startKey, DateTime now) {
  final List<int> parts = startKey.split('-').map(int.parse).toList(growable: false);
  final start = DateTime.utc(parts[0], parts[1], parts[2]);
  final nowKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final List<int> todayParts = nowKey.split('-').map(int.parse).toList(growable: false);
  final today = DateTime.utc(todayParts[0], todayParts[1], todayParts[2]);
  return today.difference(start).inDays;
}

final class const WalletCodec() extends JsonMapCodec<WalletState> {
  @override
  WalletState $decode(Map<String, Object?> input) {
    final lastGameDateKey = input['lastGameDateKey'] as String?;
    final List<String> unlockedAchievements =
        (input['unlockedAchievements'] as List<Object?>?)?.cast<String>() ?? const [];
    final Map<String, List<String>> dailyChallenges = {
      for (final MapEntry(:key, :value) in (input['dailyChallenges'] as Map<String, Object?>? ?? const {}).entries)
        key: (value! as List<Object?>).cast<String>(),
    };
    final List<String> ownedItems = (input['ownedItems'] as List<Object?>?)?.cast<String>() ?? const [];
    final Map<String, int> weeklyXp = {
      for (final MapEntry(:key, :value) in (input['weeklyXp'] as Map<String, Object?>? ?? const {}).entries)
        key: (value! as num).toInt(),
    };
    final List<String> leagueBonusClaimed = (input['leagueBonusClaimed'] as List<Object?>?)?.cast<String>() ?? const [];
    final Map<String, int> revealsPerDay = {
      for (final MapEntry(:key, :value) in (input['revealsPerDay'] as Map<String, Object?>? ?? const {}).entries)
        key: (value! as num).toInt(),
    };
    final Map<String, int> eliminatesPerDay = {
      for (final MapEntry(:key, :value) in (input['eliminatesPerDay'] as Map<String, Object?>? ?? const {}).entries)
        key: (value! as num).toInt(),
    };
    final List<int> seasonPassClaimedDays =
        (input['seasonPassClaimedDays'] as List<Object?>?)?.map((e) => (e! as num).toInt()).toList() ?? const [];
    return WalletState(
      tokens: input['tokens'] as int? ?? 0,
      xp: input['xp'] as int? ?? 0,
      totalGames: input['totalGames'] as int? ?? 0,
      totalWins: input['totalWins'] as int? ?? 0,
      levelsCompleted: input['levelsCompleted'] as int? ?? 0,
      hintsUsed: input['hintsUsed'] as int? ?? 0,
      currentStreak: input['currentStreak'] as int? ?? 0,
      maxStreak: input['maxStreak'] as int? ?? 0,
      lastGameDateKey: lastGameDateKey,
      unlockedAchievements: unlockedAchievements,
      dailyChallenges: dailyChallenges,
      ownedItems: ownedItems,
      activeAvatar: input['activeAvatar'] as String?,
      lastChestDateKey: input['lastChestDateKey'] as String?,
      weeklyXp: weeklyXp,
      leagueBonusClaimed: leagueBonusClaimed,
      revealsPerDay: revealsPerDay,
      eliminatesPerDay: eliminatesPerDay,
      seasonPassActive: input['seasonPassActive'] as bool? ?? false,
      seasonPassStartKey: input['seasonPassStartKey'] as String?,
      seasonPassClaimedDays: seasonPassClaimedDays,
    );
  }

  @override
  Map<String, Object?> $encode(WalletState input) => {
    'tokens': input.tokens,
    'xp': input.xp,
    'totalGames': input.totalGames,
    'totalWins': input.totalWins,
    'levelsCompleted': input.levelsCompleted,
    'hintsUsed': input.hintsUsed,
    'currentStreak': input.currentStreak,
    'maxStreak': input.maxStreak,
    'lastGameDateKey': input.lastGameDateKey,
    'unlockedAchievements': input.unlockedAchievements,
    'dailyChallenges': input.dailyChallenges,
    'ownedItems': input.ownedItems,
    'activeAvatar': input.activeAvatar,
    'lastChestDateKey': input.lastChestDateKey,
    'weeklyXp': input.weeklyXp,
    'leagueBonusClaimed': input.leagueBonusClaimed,
    'revealsPerDay': input.revealsPerDay,
    'eliminatesPerDay': input.eliminatesPerDay,
    'seasonPassActive': input.seasonPassActive,
    'seasonPassStartKey': input.seasonPassStartKey,
    'seasonPassClaimedDays': input.seasonPassClaimedDays,
  };
}
