import 'package:flutter/material.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/wallet_state.dart';

enum AchievementId() {
  firstWin,
  fiveWins,
  twentyFiveWins,
  streak3,
  streak7,
  tenLevels,
  fiftyLevels,
  rich,
  hintUser;

  String get name => switch (this) {
    AchievementId.firstWin => 'achFirstWin',
    AchievementId.fiveWins => 'achFiveWins',
    AchievementId.twentyFiveWins => 'achTwentyFiveWins',
    AchievementId.streak3 => 'achStreak3',
    AchievementId.streak7 => 'achStreak7',
    AchievementId.tenLevels => 'achTenLevels',
    AchievementId.fiftyLevels => 'achFiftyLevels',
    AchievementId.rich => 'achRich',
    AchievementId.hintUser => 'achHintUser',
  };
}

@immutable
final class const Achievement({
  required final AchievementId id,
  required final IconData icon,
  required final int tokenReward,
  required final bool Function(WalletState wallet) isUnlocked,
}) {
  String get titleKey => id.name;

  String get descriptionKey => '${id.name}Desc';
}

@immutable
final class const AchievementsCatalog() {
  static final List<Achievement> all = [
    Achievement(
      id: AchievementId.firstWin,
      icon: Icons.emoji_events,
      tokenReward: 50,
      isUnlocked: (w) => w.totalWins >= 1,
    ),
    Achievement(
      id: AchievementId.fiveWins,
      icon: Icons.military_tech,
      tokenReward: 75,
      isUnlocked: (w) => w.totalWins >= 5,
    ),
    Achievement(
      id: AchievementId.twentyFiveWins,
      icon: Icons.workspace_premium,
      tokenReward: 150,
      isUnlocked: (w) => w.totalWins >= 25,
    ),
    Achievement(
      id: AchievementId.streak3,
      icon: Icons.local_fire_department,
      tokenReward: 50,
      isUnlocked: (w) => w.maxStreak >= 3,
    ),
    Achievement(id: AchievementId.streak7, icon: Icons.whatshot, tokenReward: 100, isUnlocked: (w) => w.maxStreak >= 7),
    Achievement(
      id: AchievementId.tenLevels,
      icon: Icons.trending_up,
      tokenReward: 100,
      isUnlocked: (w) => w.levelsCompleted >= 10,
    ),
    Achievement(
      id: AchievementId.fiftyLevels,
      icon: Icons.rocket_launch,
      tokenReward: 200,
      isUnlocked: (w) => w.levelsCompleted >= 50,
    ),
    Achievement(
      id: AchievementId.rich,
      icon: Icons.account_balance_wallet,
      tokenReward: 250,
      isUnlocked: (w) => w.tokens >= 500,
    ),
    Achievement(
      id: AchievementId.hintUser,
      icon: Icons.psychology,
      tokenReward: 40,
      isUnlocked: (w) => w.hintsUsed >= 3,
    ),
  ];
}
