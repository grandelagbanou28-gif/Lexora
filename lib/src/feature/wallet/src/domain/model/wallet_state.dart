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
}) {
  static const int xpPerLevel = 100;

  int get playerLevel => 1 + xp ~/ xpPerLevel;

  int get levelProgress => xp % xpPerLevel;

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
  );
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
  };
}
