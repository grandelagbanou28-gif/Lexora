import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

/// A dashboard with the player level, tokens, daily challenges and achievements.
class const ProfilePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    return Title(
      color: Colors.black,
      title: context.l10n.profile,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.profile, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ValueListenableBuilder<WalletState>(
          valueListenable: wallet.notifier,
          builder: (context, state, _) {
            return ConstraintScreen(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _LevelCard(state: state),
                    const SizedBox(height: 16),
                    _BalanceCard(state: state),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.dailyChallenges.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DailyChallengesCard(state: state),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.achievements.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AchievementsCard(state: state),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class const _LevelCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GeneralSettings general = SettingsScope.of(context, listen: true).settingsService.current.general;
    final int played = state.totalGames;
    final int wins = state.totalWins;
    final num winRate = played != 0 ? wins * 100 / played : 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Text(
              state.playerLevel.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 44),
            ),
            Text(context.l10n.playerLevel, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.levelProgress / WalletState.xpPerLevel,
                minHeight: 8,
                color: LetterStatus.correctSpot.cellColor(context, general),
                backgroundColor: LetterStatus.unknown.cellColor(context, general),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatText(value: played, title: context.l10n.played),
                _StatText(value: winRate, title: context.l10n.winRate, percent: true),
                _StatText(value: state.currentStreak, title: context.l10n.currentStreak),
                _StatText(value: state.maxStreak, title: context.l10n.maxStreak),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class const _BalanceCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BalanceItem(
              icon: Icons.monetization_on,
              value: state.tokens.toString(),
              title: context.l10n.tokens,
            ),
            _BalanceItem(
              icon: Icons.psychology_outlined,
              value: state.hintsUsed.toString(),
              title: context.l10n.hints,
            ),
            _BalanceItem(
              icon: Icons.emoji_events_outlined,
              value: state.levelsCompleted.toString(),
              title: context.l10n.levels,
            ),
          ],
        ),
      ),
    );
  }
}

class const _BalanceItem({
  required final IconData icon,
  required final String value,
  required final String title,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class const _DailyChallengesCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> done = List.of(state.dailyChallenges[_todayKey()] ?? const []);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          for (final DailyChallenge challenge in DailyChallengesCatalog.all)
            _ChallengeTile(
              challenge: challenge,
              completed: done.contains(challenge.id.name),
            ),
        ],
      ),
    );
  }
}

class const _ChallengeTile({required final DailyChallenge challenge, required final bool completed})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          challenge.icon,
          color: completed ? colors.primary : null,
        ),
        title: Text(_challengeTitle(context, challenge.id)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${challenge.reward}'),
            const SizedBox(width: 2),
            Icon(Icons.monetization_on, size: 18, color: colors.primary),
            const SizedBox(width: 8),
            if (completed)
              Icon(Icons.check_circle, color: colors.primary)
            else
              Icon(Icons.radio_button_unchecked, color: colors.outline),
          ],
        ),
      ),
    );
  }
}

class const _AchievementsCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 520 ? 1 : 2;
          final double width = constraints.maxWidth / columns;
          return Wrap(
            children: [
              for (final Achievement achievement in AchievementsCatalog.all)
                SizedBox(
                  width: width,
                  child: _AchievementTile(
                    achievement: achievement,
                    unlocked: state.unlockedAchievements.contains(achievement.id.name),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class const _AchievementTile({required final Achievement achievement, required final bool unlocked})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double opacity = unlocked ? 1 : 0.45;
    return Card(
      margin: const EdgeInsets.all(4),
      child: Opacity(
        opacity: opacity,
        child: ListTile(
          leading: Icon(achievement.icon),
          title: Text(_achievementTitle(context, achievement.id)),
          subtitle: Text(_achievementDesc(context, achievement.id)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${achievement.tokenReward}'),
                  Icon(Icons.monetization_on, size: 16, color: colors.primary),
                ],
              ),
              Text(
                unlocked ? context.l10n.achievementsUnlocked : context.l10n.achievementsLocked,
                style: TextStyle(
                  fontSize: 11,
                  color: unlocked ? colors.primary : colors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _todayKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _challengeTitle(BuildContext context, DailyChallengeId id) => switch (id) {
  DailyChallengeId.word => context.l10n.dailyChallengeWord,
  DailyChallengeId.fast => context.l10n.dailyChallengeFast,
  DailyChallengeId.streak => context.l10n.dailyChallengeStreak,
};

String _achievementTitle(BuildContext context, AchievementId id) => switch (id) {
  AchievementId.firstWin => context.l10n.achFirstWin,
  AchievementId.fiveWins => context.l10n.achFiveWins,
  AchievementId.twentyFiveWins => context.l10n.achTwentyFiveWins,
  AchievementId.streak3 => context.l10n.achStreak3,
  AchievementId.streak7 => context.l10n.achStreak7,
  AchievementId.tenLevels => context.l10n.achTenLevels,
  AchievementId.fiftyLevels => context.l10n.achFiftyLevels,
  AchievementId.rich => context.l10n.achRich,
  AchievementId.hintUser => context.l10n.achHintUser,
};

String _achievementDesc(BuildContext context, AchievementId id) => switch (id) {
  AchievementId.firstWin => context.l10n.achFirstWinDesc,
  AchievementId.fiveWins => context.l10n.achFiveWinsDesc,
  AchievementId.twentyFiveWins => context.l10n.achTwentyFiveWinsDesc,
  AchievementId.streak3 => context.l10n.achStreak3Desc,
  AchievementId.streak7 => context.l10n.achStreak7Desc,
  AchievementId.tenLevels => context.l10n.achTenLevelsDesc,
  AchievementId.fiftyLevels => context.l10n.achFiftyLevelsDesc,
  AchievementId.rich => context.l10n.achRichDesc,
  AchievementId.hintUser => context.l10n.achHintUserDesc,
};

class const _StatText({required final num value, required final String title, final bool percent = false})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        percent ? '${value.toStringAsFixed(1)}%' : value.toString(),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 4),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
    ],
  );
}
