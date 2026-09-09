import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

/// Visual style of a league tier.
@immutable
final class const _TierStyle({required final int minXp, required final Color color, required final String labelKey}) {
  String label(BuildContext context) => switch (labelKey) {
    'bronze' => context.l10n.leagueBronze,
    'silver' => context.l10n.leagueSilver,
    'gold' => context.l10n.leagueGold,
    _ => context.l10n.leagueDiamond,
  };
}

const List<_TierStyle> _tiers = [
  _TierStyle(minXp: 0, color: Color(0xFFB08D57), labelKey: 'bronze'),
  _TierStyle(minXp: 100, color: Color(0xFF9E9E9E), labelKey: 'silver'),
  _TierStyle(minXp: 250, color: Color(0xFFE0A526), labelKey: 'gold'),
  _TierStyle(minXp: 500, color: Color(0xFF6C5CE7), labelKey: 'diamond'),
];

/// Weekly leagues: earn XP by language and claim end-of-week bonuses.
class const LeaguePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    return Title(
      color: Colors.black,
      title: context.l10n.league,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.league, style: const TextStyle(fontWeight: FontWeight.w700)),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(context.l10n.leagueSubtitle, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 24),
                    _WeekCard(state: state),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.leaguePerLanguage.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final Locale locale in Localization.supportedDictionaryLocales)
                      _LanguageRow(state: state, locale: locale),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.leaguePrevious.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final Locale locale in Localization.supportedDictionaryLocales)
                      _PreviousWeekTile(state: state, locale: locale),
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

class const _WeekCard({required final WalletState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int total = _weeklyTotal(state, DateTime.now());
    final int tier = leagueXpTier(total);
    final _TierStyle style = _tiers[tier - 1];
    final _TierStyle next = tier < _tiers.length ? _tiers[tier] : _tiers.last;
    final double progress = tier < _tiers.length
        ? ((total - style.minXp) / (next.minXp - style.minXp)).clamp(0.0, 1.0)
        : 1.0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.workspace_premium, size: 48, color: style.color),
            const SizedBox(height: 8),
            Text(style.label(context), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
            const SizedBox(height: 4),
            Text(context.l10n.leagueThisWeek, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, minHeight: 10, color: style.color),
            ),
            const SizedBox(height: 8),
            Text(
              tier < _tiers.length ? _nextLabel(context, tier) : context.l10n.leagueDiamondNext,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text('$total ${context.l10n.xp}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class const _LanguageRow({required final WalletState state, required final Locale locale}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int xp = _langWeekly(state, locale.languageCode, DateTime.now());
    final int tier = leagueXpTier(xp);
    final _TierStyle style = _tiers[tier - 1];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(locale.languageCode.toUpperCase())),
        title: Text(style.label(context)),
        subtitle: Text('$xp ${context.l10n.xp}'),
        trailing: Icon(Icons.circle, size: 14, color: style.color),
      ),
    );
  }
}

class const _PreviousWeekTile({required final WalletState state, required final Locale locale})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    final previousKey = '${locale.languageCode}|${leagueWeekKey(DateTime.now().subtract(const Duration(days: 7)))}';
    final int previous = state.weeklyXp[previousKey] ?? 0;
    final bool claimed = state.leagueBonusClaimed.contains(previousKey);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        enabled: previous > 0,
        leading: CircleAvatar(child: Text(locale.languageCode.toUpperCase())),
        title: Text('$previous ${context.l10n.xp}'),
        subtitle: Text(claimed ? context.l10n.leagueClaimed : context.l10n.leagueReward),
        trailing: previous == 0
            ? Text(context.l10n.leagueNoPrevious, style: const TextStyle(fontSize: 12))
            : claimed
            ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
            : FilledButton.tonal(
                onPressed: () async {
                  final int bonus = await wallet.claimLeagueBonus(locale.languageCode, DateTime.now());
                  if (!context.mounted || bonus == 0) {
                    return;
                  }
                  context.dependencies.soundService.coins();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('+$bonus ${context.l10n.xp} (${context.l10n.leagueClaim})')));
                },
                child: Text(context.l10n.leagueClaim),
              ),
      ),
    );
  }
}

int _weeklyTotal(WalletState state, DateTime now) {
  final String weekKey = leagueWeekKey(now);
  var total = 0;
  for (final MapEntry(:key, :value) in state.weeklyXp.entries) {
    if (key.endsWith('|$weekKey')) {
      total += value;
    }
  }
  return total;
}

int _langWeekly(WalletState state, String languageCode, DateTime now) {
  return state.weeklyXp['$languageCode|${leagueWeekKey(now)}'] ?? 0;
}

String _nextLabel(BuildContext context, int tier) => switch (tier) {
  1 => context.l10n.leagueBronzeNext,
  2 => context.l10n.leagueSilverNext,
  _ => context.l10n.leagueGoldNext,
};
