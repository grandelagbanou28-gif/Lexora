import 'package:flutter/material.dart';

enum DailyChallengeId() {
  word,
  fast,
  streak,
  noHint,
  ecoWin;

  String get name => switch (this) {
    DailyChallengeId.word => 'dailyChallengeWord',
    DailyChallengeId.fast => 'dailyChallengeFast',
    DailyChallengeId.streak => 'dailyChallengeStreak',
    DailyChallengeId.noHint => 'dailyChallengeNoHint',
    DailyChallengeId.ecoWin => 'dailyChallengeEcoWin',
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
    DailyChallenge(id: DailyChallengeId.noHint, icon: Icons.remove_red_eye_outlined, reward: 35),
    DailyChallenge(id: DailyChallengeId.ecoWin, icon: Icons.recycling, reward: 30),
  ];
}
