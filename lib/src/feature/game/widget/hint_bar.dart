import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/keyboard.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

/// A compact bar with the paid hint actions of the game.
class const HintBar({super.key}) extends StatelessWidget {
  static const int wordLength = 5;
  static const int revealCost = 20;
  static const int eliminateCost = 30;

  @override
  Widget build(BuildContext context) {
    final GameState state = context.watch<GameBloc>().state;
    final WalletService wallet = WalletScope.of(context);
    final int rowStart = state.board.isEmpty ? 0 : state.currentWordIndex * wordLength;
    final int placed = state.board.length - rowStart;
    final bool revealEnabled = !state.isInputBlocked && placed < wordLength;
    final int remaining = _remainingLetters(state).length;
    final bool eliminateEnabled = !state.isInputBlocked && remaining > 0;

    return ValueListenableBuilder<WalletState>(
      valueListenable: wallet.notifier,
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text('${value.tokens}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              _HintButton(
                tooltip: context.l10n.revealLetter,
                costText: '$revealCost',
                icon: Icons.visibility_outlined,
                enabled: revealEnabled,
                onTap: () => _revealLetter(context),
              ),
              const SizedBox(width: 8),
              _HintButton(
                tooltip: context.l10n.eliminateLetters,
                costText: '$eliminateCost',
                icon: Icons.backspace_outlined,
                enabled: eliminateEnabled,
                onTap: () => _eliminateLetters(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Set<String> _remainingLetters(GameState state) {
    final (List<String>, List<String>, List<String>) keyboard = switch (state.dictionary.languageCode) {
      'ru' => KeyboardList.ruKeyboard,
      'fr' || 'fon' => KeyboardList.frKeyboard,
      _ => KeyboardList.enKeyboard,
    };
    final Set<String> letters = {...keyboard.$1, ...keyboard.$2, ...keyboard.$3};
    final Set<String> secretLetters = state.secretWord.split('').toSet();
    return letters.difference(secretLetters).difference(state.eliminatedKeys);
  }

  Future<void> _revealLetter(BuildContext context) async {
    final WalletService wallet = WalletScope.of(context);
    final bool spent = await wallet.useHint(revealCost);
    if (!context.mounted) {
      return;
    }
    if (!spent) {
      _showNotEnoughTokens(context);
      return;
    }
    context.dependencies.soundService.tokens();
    context.read<GameBloc>().add(const GameEvent.revealLetterPressed());
  }

  Future<void> _eliminateLetters(BuildContext context) async {
    final WalletService wallet = WalletScope.of(context);
    final bool spent = await wallet.useHint(eliminateCost);
    if (!context.mounted) {
      return;
    }
    if (!spent) {
      _showNotEnoughTokens(context);
      return;
    }
    context.dependencies.soundService.tokens();
    context.read<GameBloc>().add(const GameEvent.eliminateLettersPressed());
  }

  void _showNotEnoughTokens(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.notEnoughTokens),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// A single hint action button with its cost.
class const _HintButton({
  required final String tooltip,
  required final String costText,
  required final IconData icon,
  required final bool enabled,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: enabled ? colors.onSurface : colors.onSurface.withValues(alpha: 0.38)),
                const SizedBox(width: 4),
                Text(
                  costText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: enabled ? colors.onSurfaceVariant : colors.onSurfaceVariant.withValues(alpha: 0.38),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.monetization_on, size: 14, color: colors.primary.withValues(alpha: enabled ? 1 : 0.38)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
