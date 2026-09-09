import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/coin.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/shop/shop.dart';
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
                    const SizedBox(height: 16),
                    _ChestCard(state: state),
                    if (state.currentStreak == 0 && state.maxStreak >= 1) ...[
                      const SizedBox(height: 16),
                      _RepairStreakCard(state: state),
                    ],
                    const SizedBox(height: 16),
                    _SeasonPassCard(state: state),
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
            Row(
              children: [
                _AvatarBadge(state: state),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.playerLevel.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 44),
                      ),
                      Text(context.l10n.playerLevel, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
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

class const _AvatarBadge({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? avatarId = state.activeAvatar;
    final AvatarInfo? avatar = avatarId == null ? null : ShopCatalog.avatarById(avatarId);
    return CircleAvatar(
      radius: 28,
      backgroundColor: avatar?.color ?? Theme.of(context).colorScheme.primaryContainer,
      child: avatar == null
          ? Text(state.playerLevel.toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22))
          : Icon(avatar.icon, color: Colors.white, size: 30),
    );
  }
}

class const _ChestCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    final claimed = state.lastChestDateKey == _todayKey();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Icon(claimed ? Icons.check_circle_outline : Icons.card_giftcard, size: 36),
        title: Text(context.l10n.chestTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(claimed ? context.l10n.chestTomorrow : context.l10n.earnTip),
        trailing: claimed
            ? Text(context.l10n.chestTomorrow, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12))
            : FilledButton.tonalIcon(
                onPressed: () async {
                  final int reward = await wallet.claimDailyChest(DateTime.now());
                  if (!context.mounted) {
                    return;
                  }
                  if (reward > 0) {
                    context.dependencies.soundService.coins();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Text('${context.l10n.chestReward} +$reward'),
                              const SizedBox(width: 4),
                              const Coin(size: 18),
                            ],
                          ),
                        ),
                      );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(context.l10n.chestTomorrow)));
                  }
                },
                icon: const Icon(Icons.card_giftcard),
                label: Text(context.l10n.chestOpen),
              ),
      ),
    );
  }
}

class const _RepairStreakCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: const Icon(Icons.local_fire_department_outlined, size: 36),
        title: Text(context.l10n.repairStreak, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: FilledButton.tonalIcon(
          onPressed: state.tokens < 60
              ? null
              : () async {
                  final bool repaired = await wallet.repairStreak(DateTime.now());
                  if (!context.mounted) {
                    return;
                  }
                  if (repaired) {
                    context.dependencies.soundService.coins();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(context.l10n.repairStreakDone)));
                  }
                },
          icon: const Icon(Icons.local_fire_department, size: 18),
          label: const Row(mainAxisSize: MainAxisSize.min, children: [Text('60'), SizedBox(width: 2), Coin(size: 16)]),
        ),
      ),
    );
  }
}

class const _SeasonPassCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    if (!state.seasonPassActive) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListTile(
          leading: const Icon(Icons.workspace_premium_outlined, size: 36),
          title: Text(context.l10n.seasonPass, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(context.l10n.seasonPassSubtitle),
          trailing: FilledButton.tonalIcon(
            onPressed: state.tokens < seasonPassPrice
                ? null
                : () async {
                    final bool bought = await wallet.buySeasonPass(seasonPassPrice);
                    if (!context.mounted) {
                      return;
                    }
                    if (bought) {
                      context.dependencies.soundService.tokens();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(context.l10n.seasonPassBought)));
                    }
                  },
            icon: const Icon(Icons.workspace_premium, size: 18),
            label: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('$seasonPassPrice'), SizedBox(width: 2), Coin(size: 16)],
            ),
          ),
        ),
      );
    }
    final int phase = state.seasonPassDayIndex;
    final bool finished = state.seasonPassFinished;
    final int claimedCount = state.seasonPassClaimedDays.length;
    final int current = finished ? 7 : phase + 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    finished ? context.l10n.seasonPassFinished : context.l10n.seasonPass,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text('$claimedCount/7', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: current / 7,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (var day = 0; day < seasonPassRewards.length; day++) _dayChip(context, day, state)],
            ),
            const SizedBox(height: 12),
            if (!finished && !state.seasonPassClaimedDays.contains(phase))
              FilledButton.icon(
                onPressed: () async {
                  final int reward = await wallet.claimSeasonPassReward(DateTime.now());
                  if (!context.mounted) {
                    return;
                  }
                  if (reward > 0) {
                    context.dependencies.soundService.tokens();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [Text('${context.l10n.seasonPassClaim} +$reward'), const Coin(size: 18)],
                          ),
                        ),
                      );
                  }
                },
                icon: const Icon(Icons.card_giftcard),
                label: Text(context.l10n.seasonPassClaim),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(BuildContext context, int day, WalletState state) {
    final bool active = !state.seasonPassFinished && day <= state.seasonPassDayIndex;
    final bool claimed = state.seasonPassClaimedDays.contains(day);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: claimed
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day + 1}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Coin(size: 12),
              const SizedBox(width: 2),
              Text('${seasonPassRewards[day]}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
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
            _BalanceItem(icon: const Coin(size: 28), value: state.tokens.toString(), title: context.l10n.tokens),
            _BalanceItem(
              icon: const Icon(Icons.psychology_outlined, size: 28),
              value: state.hintsUsed.toString(),
              title: context.l10n.hints,
            ),
            _BalanceItem(
              icon: const Icon(Icons.emoji_events_outlined, size: 28),
              value: state.levelsCompleted.toString(),
              title: context.l10n.levels,
            ),
          ],
        ),
      ),
    );
  }
}

class const _BalanceItem({required final Widget icon, required final String value, required final String title})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
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
            _ChallengeTile(challenge: challenge, completed: done.contains(challenge.id.name)),
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
        leading: Icon(challenge.icon, color: completed ? colors.primary : null),
        title: Text(_challengeTitle(context, challenge.id)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${challenge.reward}'),
            const SizedBox(width: 2),
            const Coin(size: 18),
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
                children: [Text('${achievement.tokenReward}'), const SizedBox(width: 2), const Coin(size: 16)],
              ),
              Text(
                unlocked ? context.l10n.achievementsUnlocked : context.l10n.achievementsLocked,
                style: TextStyle(fontSize: 11, color: unlocked ? colors.primary : colors.outline),
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
  DailyChallengeId.noHint => context.l10n.dailyChallengeNoHint,
  DailyChallengeId.ecoWin => context.l10n.dailyChallengeEcoWin,
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
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
