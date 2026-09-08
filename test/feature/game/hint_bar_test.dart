import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/game/domain/repositories/game_repository.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/level/domain/model/level_result.dart';
import 'package:wordly/src/feature/level/domain/repositories/level_repository.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/sound/sound.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';
import 'package:wordly/src/feature/statistic/domain/repositories/statistics_repository.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

void main() {
  testWidgets('reveal hint spends tokens and inserts a correct letter', (tester) async {
    final GameBloc bloc = await _pumpGame(tester, tokens: 100);
    await _pushLetters(bloc, 'ci');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();

    expect(bloc.state.board.length, 3);
    expect(find.text('80'), findsOneWidget);
  });

  testWidgets('hint without enough tokens shows a snackbar and changes nothing', (tester) async {
    final GameBloc bloc = await _pumpGame(tester, tokens: 10);
    await _pushLetters(bloc, 'ci');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Not enough tokens'), findsOneWidget);
    expect(bloc.state.board.length, 2);
  });
}

Future<GameBloc> _pumpGame(WidgetTester tester, {required int tokens}) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final SharedPreferencesAsyncPlatform? previousPreferencesPlatform = SharedPreferencesAsyncPlatform.instance;
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  addTearDown(() => SharedPreferencesAsyncPlatform.instance = previousPreferencesPlatform);

  final prefs = SharedPreferencesAsync();
  await prefs.setString('wallet', jsonEncode(const WalletCodec().encode(WalletState(tokens: tokens))));
  final SettingsContainer settings = await SettingsContainer.create(sharedPreferences: prefs);
  final WalletContainer walletContainer = await WalletContainer.create(sharedPreferences: prefs);
  final levelRepository = _LevelRepository();
  final gameRepository = _GameRepository();
  final bloc = GameBloc(
    dictionary: const Locale('en'),
    gameRepository: gameRepository,
    statisticsRepository: const _StatisticsRepository(),
    levelRepository: levelRepository,
    savedResult: null,
  );
  addTearDown(bloc.close);
  final dependencies = DependenciesContainer(
    config: const ApplicationConfig(),
    packageInfo: PackageInfo(appName: 'Wordly', packageName: 'wordly', version: 'test', buildNumber: '1'),
    settingsContainer: settings,
    statisticsRepository: const _StatisticsRepository(),
    levelRepository: levelRepository,
    gameRepository: gameRepository,
    walletContainer: walletContainer,
    soundService: SoundService(settingsService: settings.settingsService),
  );
  await tester.pumpWidget(
    DependenciesScope(
      dependencies: dependencies,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: Localization.localizationDelegates,
        supportedLocales: Localization.supportedLocales,
        home: BlocProvider<GameBloc>.value(
          value: bloc,
          child: const Scaffold(body: GameBody()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  bloc.add(const GameEvent.changeGameMode(GameMode.lvl));
  await bloc.stream.firstWhere((state) => state.gameMode == GameMode.lvl && state.lvlNumber == 1);
  await tester.pumpAndSettle();
  return bloc;
}

Future<void> _pushLetters(GameBloc bloc, String word) async {
  final int targetLength = bloc.state.board.length + word.length;
  for (final String letter in word.split('')) {
    bloc.add(GameEvent.letterPressed(letter));
  }
  await bloc.stream.firstWhere((state) => state.board.length == targetLength);
}

final class _GameRepository() implements IGameRepository {
  @override
  Map<String, String> currentDictionary(Locale dictionary) => const {'apple': 'apple', 'cider': 'cider'};

  @override
  String generateSecretWord(Locale dictionary, {int levelNumber = 0}) => 'apple';

  @override
  Future<GameResult?> getDaily(Locale dictionary, DateTime date) async => null;

  @override
  Future<void> init(Locale dictionary) async {}

  @override
  Future<bool> get isFirstEnter async => false;

  @override
  GameResult? get savedResult => null;

  @override
  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult) async {}

  @override
  Future<void> setFirstEnter() async {}
}

final class _LevelRepository() implements ILevelRepository {
  @override
  Future<void> completeLevel({
    required Locale dictionary,
    required GameResult completedLevel,
    required GameResult nextLevel,
  }) async {}

  @override
  Future<GameResult?> getCurrentProgress(Locale dictionary) async =>
      const GameResult(secretWord: 'apple', lvlNumber: 1);

  @override
  Future<List<LevelResult>> getResults(Locale dictionary) async => const [];

  @override
  Future<void> saveCurrentProgress(Locale dictionary, GameResult progress) async {}
}

final class const _StatisticsRepository() implements IStatisticsRepository {
  @override
  Future<GameStatistic?> getStatistic(String dictionary) async => null;

  @override
  Future<void> saveStatistic(String dictionary, {required bool isWin, required int attempt}) async {}
}
