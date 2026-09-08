import 'package:flutter/material.dart';

enum DailyChallengeId() {
  word,
  fast,
  streak;

  String get name => switch (this) {
    DailyChallengeId.word => 'dailyChallengeWord',
    DailyChallengeId.fast => 'dailyChallengeFast',
    DailyChallengeId.streak => 'dailyChallengeStreak',
  };
}

@immutable
final class const DailyChallenge({
  required final DailyChallengeId id,
  required final IconData icon,
  final int reward = 10,
}) {
  String get titleKey => id.name;
}

@immutable
final class const DailyChallengesCatalog() {
  static const List<DailyChallenge> all = [
    DailyChallenge(id: DailyChallengeId.word, icon: Icons.edit),
    DailyChallenge(id: DailyChallengeId.fast, icon: Icons.bolt, reward: 20),
    DailyChallenge(id: DailyChallengeId.streak, icon: Icons.local_fire_department, reward: 30),
  ];
}
