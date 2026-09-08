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
  );
}

final class const WalletCodec() extends JsonMapCodec<WalletState> {
  @override
  WalletState $decode(Map<String, Object?> input) {
    final lastGameDateKey = input['lastGameDateKey'] as String?;
    final List<String> unlockedAchievements =
        (input['unlockedAchievements'] as List<Object?>?)?.cast<String>() ?? const [];
    final Map<String, List<String>> dailyChallenges = {
      for (final MapEntry(:key, :value)
          in (input['dailyChallenges'] as Map<String, Object?>? ?? const {}).entries)
        key: (value! as List<Object?>).cast<String>(),
    };
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
  };
}
