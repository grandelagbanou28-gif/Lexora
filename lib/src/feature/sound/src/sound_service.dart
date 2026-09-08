import 'dart:async' show unawaited;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:wordly/src/feature/settings/settings.dart';

enum SoundEffect() {
  keyPress,
  enter,
  correct,
  wrongSpot,
  notInWord,
  win,
  lose,
  levelUp,
  tokens,
  achievement;

  String get asset => switch (this) {
    SoundEffect.keyPress => 'sounds/key_press.wav',
    SoundEffect.enter => 'sounds/enter.wav',
    SoundEffect.correct => 'sounds/correct.wav',
    SoundEffect.wrongSpot => 'sounds/wrong_spot.wav',
    SoundEffect.notInWord => 'sounds/not_in_word.wav',
    SoundEffect.win => 'sounds/win.wav',
    SoundEffect.lose => 'sounds/lose.wav',
    SoundEffect.levelUp => 'sounds/level_up.wav',
    SoundEffect.tokens => 'sounds/tokens.wav',
    SoundEffect.achievement => 'sounds/achievement.wav',
  };
}

final class SoundService({
  required final SettingsService _settingsService,
}) {
  final AudioPlayer _player = AudioPlayer();

  void keyPress() => play(SoundEffect.keyPress);
  void enter() => play(SoundEffect.enter);
  void correct() => play(SoundEffect.correct);
  void wrongSpot() => play(SoundEffect.wrongSpot);
  void notInWord() => play(SoundEffect.notInWord);
  void win() => play(SoundEffect.win);
  void lose() => play(SoundEffect.lose);
  void levelUp() => play(SoundEffect.levelUp);
  void tokens() => play(SoundEffect.tokens);
  void achievement() => play(SoundEffect.achievement);

  void play(SoundEffect effect) {
    unawaited(_play(effect));
  }

  Future<void> _play(SoundEffect effect) async {
    final GeneralSettings general = _settingsService.current.general;
    try {
      if (general.vibrationEnabled) {
        await _vibrate(effect);
      }
      if (!general.soundEnabled) {
        return;
      }
      await _player.stop();
      await _player.play(AssetSource(effect.asset));
    } on Object {
      // Sound playback must never break the game flow.
    }
  }

  Future<void> _vibrate(SoundEffect effect) => switch (effect) {
    SoundEffect.win || SoundEffect.levelUp || SoundEffect.achievement => HapticFeedback.mediumImpact(),
    SoundEffect.lose => HapticFeedback.heavyImpact(),
    _ => HapticFeedback.selectionClick(),
  };
}
