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

  test('daily win grants tokens, XP, word and fast challenges and first win achievement', () async {
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
    expect(reward.challenges.map((c) => c.id), containsAll([DailyChallengeId.word, DailyChallengeId.fast]));
    final WalletState state = service.current;
    expect(state.totalGames, 1);
    expect(state.totalWins, 1);
    expect(state.currentStreak, 1);
    expect(state.maxStreak, 1);
    expect(state.lastGameDateKey, '2026-09-08');
    expect(state.unlockedAchievements, contains('achFirstWin'));
    expect(state.dailyChallenges['2026-09-08'], ['dailyChallengeFast', 'dailyChallengeWord']);
    expect(state.tokens, 25 + 50 + 10 + 20);
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
