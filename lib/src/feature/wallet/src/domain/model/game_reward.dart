import 'package:flutter/foundation.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/achievement.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/daily_challenge.dart';
import 'package:wordly/src/feature/wallet/src/domain/model/wallet_state.dart';

@immutable
final class const GameReward({
  required final WalletState wallet,
  required final int tokenDelta,
  required final int xpDelta,
  required final bool leveledUp,
  required final List<Achievement> achievements,
  required final List<DailyChallenge> challenges,
});
