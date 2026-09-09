import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

void main() {
  test('useHint spends tokens and counts a hint when affordable', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 40)),
    );
    expect(await service.useHint(20), isTrue);
    expect(service.current.tokens, 20);
    expect(service.current.hintsUsed, 1);
  });

  test('useHint refuses when tokens are insufficient', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 10)),
    );
    expect(await service.useHint(20), isFalse);
    expect(service.current.tokens, 10);
    expect(service.current.hintsUsed, 0);
  });

  test('daily win grants tokens, XP, word, fast, no-hint and eco challenges and first win achievement', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final GameReward reward = await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.tokenDelta, 25);
    expect(reward.xpDelta, 60);
    expect(reward.leveledUp, isFalse);
    expect(reward.achievements.map((a) => a.id), contains(AchievementId.firstWin));
    expect(
      reward.challenges.map((c) => c.id),
      containsAll([DailyChallengeId.word, DailyChallengeId.fast, DailyChallengeId.noHint, DailyChallengeId.ecoWin]),
    );
    final WalletState state = service.current;
    expect(state.totalGames, 1);
    expect(state.totalWins, 1);
    expect(state.currentStreak, 1);
    expect(state.maxStreak, 1);
    expect(state.lastGameDateKey, '2026-09-08');
    expect(state.unlockedAchievements, contains('achFirstWin'));
    expect(state.dailyChallenges['2026-09-08'], [
      'dailyChallengeEcoWin',
      'dailyChallengeFast',
      'dailyChallengeNoHint',
      'dailyChallengeWord',
    ]);
    expect(state.tokens, 25 + 50 + 10 + 20 + 35 + 30);
  });

  test('noHint and ecoWin challenges are not granted when a hint was used', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    await service.recordReveal(DateTime(2026, 9, 8));
    final GameReward reward = await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.challenges.map((c) => c.id), isNot(contains(DailyChallengeId.noHint)));
    expect(reward.challenges.map((c) => c.id), contains(DailyChallengeId.ecoWin));
  });

  test('practice mode gives no economy rewards', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final GameReward reward = await service.processGameResult(
      mode: GameMode.practice,
      isWin: true,
      attempt: 4,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.tokenDelta, 0);
    expect(reward.xpDelta, 0);
    expect(reward.challenges, isEmpty);
    expect(service.current.totalGames, 1);
    expect(service.current.totalWins, 1);
  });

  test('friend mode rewards a win but no challenges and no streak', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final GameReward reward = await service.processGameResult(
      mode: GameMode.friend,
      isWin: true,
      attempt: 2,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.tokenDelta, 20);
    expect(reward.xpDelta, 40);
    expect(reward.challenges, isEmpty);
    expect(service.current.currentStreak, 0);
    expect(service.current.totalWins, 1);
  });

  test('hard mode multiplies XP on daily and lvl wins', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final GameReward daily = await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
      hardMode: true,
    );
    expect(daily.xpDelta, 90);

    final GameReward lvl = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 9),
      dictionary: 'en',
      hardMode: true,
    );
    expect(lvl.xpDelta, 60);
  });

  test('boss level adds the bonus to the reward', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(unlockedAchievements: ['achFirstWin'])),
    );
    final GameReward reward = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
      bonus: 20,
    );

    expect(reward.bonus, 20);
    expect(reward.tokenDelta, 15);
    expect(service.current.tokens, 15 + 20);
  });

  test('repairStreak restores a broken streak once', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100, maxStreak: 5)),
    );
    expect(await service.repairStreak(DateTime(2026, 9, 9)), isTrue);
    expect(service.current.tokens, 40);
    expect(service.current.currentStreak, 1);
    expect(service.current.lastGameDateKey, '2026-09-08');

    expect(await service.repairStreak(DateTime(2026, 9, 9)), isFalse);
    expect(service.current.tokens, 40);
  });

  test('repairStreak refuses when the streak is alive or never started', () async {
    final WalletService active = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100, currentStreak: 2, maxStreak: 2)),
    );
    expect(await active.repairStreak(DateTime(2026, 9, 9)), isFalse);

    final WalletService fresh = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100)),
    );
    expect(await fresh.repairStreak(DateTime(2026, 9, 9)), isFalse);

    final WalletService poor = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 10, maxStreak: 3)),
    );
    expect(await poor.repairStreak(DateTime(2026, 9, 9)), isFalse);
  });

  test('weekend chest is worth up to twice a weekday chest', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final int weekday = await service.claimDailyChest(DateTime(2026, 9, 8)); // monday
    expect(weekday, inInclusiveRange(5, 25));

    final WalletService weekend = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final int sat = await weekend.claimDailyChest(DateTime(2026, 9, 12)); // saturday
    expect(sat, inInclusiveRange(10, 50));
    expect(sat, dailyChestReward(DateTime(2026, 9, 12)));
    expect(sat, greaterThan(weekday));
  });

  test('season pass buys once and claims daily rewards in order', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 300)),
    );
    final start = DateTime.now();
    expect(service.current.seasonPassActive, isFalse);
    expect(await service.buySeasonPass(seasonPassPrice, now: start), isTrue);
    expect(service.current.seasonPassActive, isTrue);
    expect(service.current.tokens, 200);
    expect(await service.buySeasonPass(seasonPassPrice, now: start), isFalse);

    expect(await service.claimSeasonPassReward(start), seasonPassRewards[0]);
    expect(service.current.seasonPassClaimedDays, [0]);
    expect(await service.claimSeasonPassReward(start), 0);

    expect(await service.claimSeasonPassReward(start.add(const Duration(days: 1))), seasonPassRewards[1]);
    expect(await service.claimSeasonPassReward(start.add(const Duration(days: 2))), seasonPassRewards[2]);
  });

  test('season pass claims all 7 daily rewards and then stops', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 300)),
    );
    final start = DateTime.now();
    await service.buySeasonPass(seasonPassPrice, now: start);
    var total = 0;
    for (var i = 0; i < seasonPassRewards.length; i++) {
      total += await service.claimSeasonPassReward(start.add(Duration(days: i)));
    }
    expect(total, seasonPassRewards.fold(0, (a, b) => a + b));
    expect(service.current.seasonPassClaimedDays.length, 7);
    expect(service.current.seasonPassDayIndexAt(start.add(const Duration(days: 7))), 7);
    expect(await service.claimSeasonPassReward(start.add(const Duration(days: 7))), 0);
    expect(service.current.seasonPassClaimedDays.length, 7);
  });

  test('daily loss resets streak and completes only the word challenge', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(currentStreak: 5, maxStreak: 5)),
    );
    final GameReward reward = await service.processGameResult(
      mode: GameMode.daily,
      isWin: false,
      attempt: 5,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.tokenDelta, 5);
    expect(reward.xpDelta, 10);
    expect(reward.challenges.map((c) => c.id), [DailyChallengeId.word]);
    expect(service.current.currentStreak, 0);
    expect(service.current.maxStreak, 5);
  });

  test('streak grows on consecutive daily wins and completes the streak challenge', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 5,
      now: DateTime(2026, 9, 6),
      dictionary: 'en',
    );
    await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 5,
      now: DateTime(2026, 9, 7),
      dictionary: 'en',
    );
    final GameReward reward = await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 5,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.challenges.map((c) => c.id), contains(DailyChallengeId.streak));
    expect(service.current.currentStreak, 3);
    expect(service.current.maxStreak, 3);
    expect(service.current.unlockedAchievements, contains('achStreak3'));
  });

  test('lvl win completes a level and lvl loss grants the smaller reward', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final GameReward win = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 2,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );
    expect(win.tokenDelta, 15);
    expect(win.xpDelta, 40);
    expect(service.current.levelsCompleted, 1);

    final GameReward loss = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: false,
      attempt: 6,
      now: DateTime(2026, 9, 9),
      dictionary: 'en',
    );
    expect(loss.tokenDelta, 2);
    expect(loss.xpDelta, 5);
    expect(service.current.levelsCompleted, 1);
  });

  test('XP crossing the level boundary reports leveledUp', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(xp: 90)),
    );
    final GameReward reward = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 2,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.leveledUp, isTrue);
    expect(service.current.playerLevel, 2);
    expect(service.current.levelProgress, 30);
  });

  test('high balance unlocks the rich achievement once', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(
        const WalletState(tokens: 490, totalWins: 1, unlockedAchievements: ['achFirstWin']),
      ),
    );
    final GameReward reward = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 2,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(service.current.tokens, 490 + 15 + 250);
    expect(reward.achievements.map((a) => a.id), [AchievementId.rich]);

    final GameReward second = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 2,
      now: DateTime(2026, 9, 9),
      dictionary: 'en',
    );
    expect(second.achievements, isEmpty);
  });

  test('hintUser unlocks after three hints', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100)),
    );
    for (var i = 0; i < 3; i++) {
      await service.useHint(20);
    }
    final GameReward reward = await service.processGameResult(
      mode: GameMode.lvl,
      isWin: true,
      attempt: 5,
      now: DateTime(2026, 9, 8),
      dictionary: 'en',
    );

    expect(reward.achievements.map((a) => a.id), contains(AchievementId.hintUser));
    expect(service.current.hintsUsed, 3);
  });

  test('purchaseItem deducts tokens and records ownership once', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100)),
    );
    expect(await service.purchaseItem('ocean', 100), isTrue);
    expect(service.current.tokens, 0);
    expect(service.current.ownedItems, ['ocean']);

    expect(await service.purchaseItem('ocean', 100), isFalse);
    expect(service.current.tokens, 0);
    expect(await service.purchaseItem('forest', 150), isFalse);
    expect(service.current.ownedItems, ['ocean']);
  });

  test('setActiveAvatar only allows owned avatars', () async {
    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(tokens: 100)),
    );
    expect(await service.setActiveAvatar('fox'), isFalse);
    await service.purchaseItem('fox', 80);
    expect(await service.setActiveAvatar('fox'), isTrue);
    expect(service.current.activeAvatar, 'fox');
  });

  test('claimDailyChest gives a deterministic reward once per day', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    final int before = service.current.tokens;
    final int first = await service.claimDailyChest(DateTime(2026, 9, 8));
    expect(first, inInclusiveRange(5, 25));
    expect(service.current.tokens - before, first);
    expect(service.current.lastChestDateKey, '2026-09-08');

    expect(await service.claimDailyChest(DateTime(2026, 9, 8)), 0);
    expect(service.current.tokens - before, first);

    expect(await service.claimDailyChest(DateTime(2026, 9, 9)), greaterThan(0));
    expect(service.current.lastChestDateKey, '2026-09-09');
  });

  test('processGameResult accumulates weekly XP per dictionary', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    await service.processGameResult(
      mode: GameMode.daily,
      isWin: true,
      attempt: 3,
      now: DateTime(2026, 9, 8),
      dictionary: 'fr',
    );
    expect(service.current.weeklyXp['fr|2026-W37'], 60);
    expect(service.current.weeklyXp['en|2026-W37'], isNull);
    expect(leagueWeekKey(DateTime(2026, 9, 8)), '2026-W37');
  });

  test('league tiering and end-of-week bonus are claimed once', () async {
    expect(leagueXpTier(50), 1);
    expect(leagueXpTier(150), 2);
    expect(leagueXpTier(300), 3);
    expect(leagueXpTier(600), 4);
    expect(leagueBonusFor(300), 60);

    final WalletService service = await WalletService.create(
      repository: _FakeWalletRepository(const WalletState(weeklyXp: {'en|2026-W36': 300})),
    );
    expect(await service.claimLeagueBonus('en', DateTime(2026, 9, 8)), 60);
    expect(service.current.xp, 60);
    expect(service.current.leagueBonusClaimed, ['en|2026-W36']);
    expect(await service.claimLeagueBonus('en', DateTime(2026, 9, 8)), 0);
    expect(service.current.xp, 60);
  });

  test('no bonus when last week had no XP', () async {
    final WalletService service = await WalletService.create(repository: _FakeWalletRepository(const WalletState()));
    expect(await service.claimLeagueBonus('en', DateTime(2026, 9, 8)), 0);
  });
}

final class _FakeWalletRepository(final WalletState wallet) implements WalletRepository {
  @override
  Future<WalletState> read() async => wallet;

  @override
  Future<void> save(WalletState value) async {}
}
