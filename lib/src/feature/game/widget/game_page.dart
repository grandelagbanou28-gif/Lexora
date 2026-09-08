import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/common/src/utils/share.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/game/domain/model/word_error.dart';
import 'package:wordly/src/feature/game/domain/repositories/game_repository.dart';
import 'package:wordly/src/feature/game/widget/game_result_dialog.dart';
import 'package:wordly/src/feature/game/widget/hint_bar.dart';
import 'package:wordly/src/feature/game/widget/keyboard_by_language.dart';
import 'package:wordly/src/feature/game/widget/words_grid.dart';
import 'package:wordly/src/feature/level/level.dart';
import 'package:wordly/src/feature/level/widget/level_page.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/coin.dart';
import 'package:wordly/src/feature/shared/drawer.dart';
import 'package:wordly/src/feature/sound/sound.dart';
import 'package:wordly/src/feature/statistic/statistic.dart';
import 'package:wordly/src/feature/statistic/widget/statistic_page.dart';
import 'package:wordly/src/feature/tutorial/widget/tutorial_page.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

class const GamePage({super.key}) extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState() extends State<GamePage> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final NavigatorState navigator = Navigator.of(context);
      final IGameRepository gameRepository = context.dependencies.gameRepository;
      final GameBloc bloc = context.read<GameBloc>();
      final GameState state = bloc.state;
      if (state.isResult) {
        unawaited(
          showGameResultDialog(
            context,
            state.secretWord,
            context.dependencies.gameRepository.currentDictionary(state.dictionary)[state.secretWord] ?? '',
            state.gameMode,
            isWin: state.isWin,
            onTimerEnd: GameMode.daily == state.gameMode ? () => bloc.add(GameEvent.resetBoard(state.gameMode)) : null,
            shareString: shareString(context, state.buildResultString),
            nextLevelPressed: () => bloc.add(const GameEvent.resetBoard(GameMode.lvl)),
          ),
        );
      }
      final bool isFirstEnter = await gameRepository.isFirstEnter;
      if (isFirstEnter) {
        unawaited(gameRepository.setFirstEnter());
        navigator.push(MaterialPageRoute<void>(builder: (context) => const TutorialPage(), fullscreenDialog: true));
        return;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsContainer settingsScope = SettingsScope.of(context, listen: true);
    final Settings settings = settingsScope.settingsService.current;
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          context.read<GameBloc>().add(GameEvent.listenKeyEvent(event));
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) => Text(
              state.gameMode == GameMode.daily ? context.l10n.daily : context.l10n.levelNumber(state.lvlNumber ?? 1),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
            ),
          ),
          actions: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state.gameMode == GameMode.daily) {
                  return IconButton(
                    tooltip: context.l10n.viewStatistic,
                    icon: const Icon(Icons.leaderboard_outlined),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => StatisticPage(dictionary: settings.dictionary)),
                      );
                    },
                  );
                } else {
                  return IconButton(
                    tooltip: context.l10n.viewLevels,
                    icon: const Icon(Icons.apps),
                    onPressed: () async {
                      await Navigator.of(
                        context,
                      ).push(MaterialPageRoute<void>(builder: (context) => LevelPage(dictionary: settings.dictionary)));
                    },
                  );
                }
              },
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: const GameBody(),
      ),
    );
  }
}

class const GameBody({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool useSpacer = MediaQuery.sizeOf(context).height > 800;
    return SettingsBuilder(
      builder: (context, settings) => BlocListener<GameBloc, GameState>(
        listenWhen: (previous, current) =>
            (!previous.gameCompleted &&
                current.gameCompleted &&
                previous.gameMode == current.gameMode &&
                previous.dictionary == current.dictionary &&
                current.isResult) ||
            current.isFailure,
        listener: (context, state) {
          if (state.isResult) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final GameBloc bloc = context.read<GameBloc>();
            final SoundService soundService = context.dependencies.soundService;
            if (state.isWin) {
              soundService.win();
            } else {
              soundService.lose();
            }
            unawaited(_processRewards(context, state));
            unawaited(
              showGameResultDialog(
                context,
                state.secretWord,
                context.dependencies.gameRepository.currentDictionary(state.dictionary)[state.secretWord] ?? '',
                state.gameMode,
                isWin: state.isWin,
                onTimerEnd: GameMode.daily == state.gameMode
                    ? () {
                        Navigator.of(context).pop();
                        bloc.add(GameEvent.resetBoard(state.gameMode));
                      }
                    : null,
                shareString: shareString(context, state.buildResultString),
                nextLevelPressed: () {
                  Navigator.of(context).pop();
                  bloc.add(const GameEvent.resetBoard(GameMode.lvl));
                },
              ),
            );
            return;
          }
          if (state.isFailure) {
            if (state is GamePersistenceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.progressSaveFailed),
                  duration: const Duration(days: 1),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: context.l10n.retry,
                    onPressed: () => context.read<GameBloc>().add(const GameEvent.retryLevelPersistence()),
                  ),
                ),
              );
              return;
            }
            WordError? error;
            if (state case final GameFailure e) {
              error = e.error;
            }
            if (error != null) {
              context.dependencies.soundService.notInWord();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: LetterStatus.unknown.cellColor(context, settings.general),
                content: Text(
                  error?.localizedText(context) ?? '',
                  style: TextStyle(color: LetterStatus.unknown.textColor(context, settings.general), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                width: 350,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Center(child: WordsGrid()),
              const HintBar(),
              if (useSpacer) const Spacer(),
              const Center(child: KeyboardByLanguage()),
              if (useSpacer) const Spacer(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _processRewards(BuildContext context, GameState state) async {
  final WalletService wallet = WalletScope.of(context);
  final GameReward reward = await wallet.processGameResult(
    mode: state.gameMode,
    isWin: state.isWin,
    attempt: state.board.length ~/ 5,
    now: DateTime.now(),
    dictionary: state.dictionary.languageCode,
  );
  if (!context.mounted) {
    return;
  }
  final rows = <Widget>[
    if (reward.tokenDelta != 0 || reward.xpDelta != 0)
      _RewardLine(
        showCoin: true,
        text: '+${reward.tokenDelta} ${context.l10n.tokens}  +${reward.xpDelta} ${context.l10n.xp}',
      ),
    if (reward.leveledUp)
      _RewardLine(text: '${context.l10n.levelUpTitle} ${context.l10n.playerLevel} ${reward.wallet.playerLevel}'),
    if (reward.achievements.isNotEmpty)
      _RewardLine(text: '${context.l10n.achievementsUnlocked} (+${reward.achievements.length})'),
    if (reward.challenges.isNotEmpty)
      _RewardLine(text: '${context.l10n.challengeCompleted} (+${reward.challenges.length})'),
  ];
  if (rows.isEmpty) {
    return;
  }
  _playRewardSound(context, reward);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Column(mainAxisSize: MainAxisSize.min, children: rows),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void _playRewardSound(BuildContext context, GameReward reward) {
  final SoundService soundService = context.dependencies.soundService;
  final bool hasChallenges = reward.challenges.isNotEmpty;
  final bool allChallenges = reward.challenges.length >= DailyChallengesCatalog.all.length;
  final bool streakMilestone = reward.achievements.any(
    (a) => a.id == AchievementId.streak3 || a.id == AchievementId.streak7,
  );
  if (hasChallenges && reward.achievements.isNotEmpty && (allChallenges || reward.challenges.length >= 2)) {
    soundService.jackpot();
  } else if (allChallenges) {
    soundService.challengeAll();
  } else if (hasChallenges) {
    soundService.challengeComplete();
  } else if (streakMilestone) {
    soundService.streakMilestone();
  } else if (reward.achievements.isNotEmpty) {
    soundService.achievement();
  } else if (reward.leveledUp) {
    soundService.levelUp();
  } else if (reward.tokenDelta > 0 || reward.xpDelta > 0) {
    soundService.coins();
  }
}

/// A single reward line inside the result Snackbar.
class const _RewardLine({required final String text, final bool showCoin = false}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showCoin) ...[const Coin(size: 16), const SizedBox(width: 6)],
        Flexible(child: Text(text, textAlign: TextAlign.center)),
      ],
    );
  }
}
