part of 'game_bloc.dart';

enum GamePersistenceOperation() {
  saveLevelProgress,
  completeLevel,
}

@Freezed()
sealed class const GameState._() with _$GameState {
  const factory idle({
    required Locale dictionary,
    required String secretWord,
    required GameMode gameMode,
    required bool gameCompleted,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required int? lvlNumber,
    @Default({}) Set<String> eliminatedKeys,
  }) = GameIdle;

  const factory loss({
    required Locale dictionary,
    required String secretWord,
    required GameMode gameMode,
    required bool gameCompleted,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required int? lvlNumber,
    @Default({}) Set<String> eliminatedKeys,
  }) = GameLoss;

  const factory win({
    required Locale dictionary,
    required String secretWord,
    required GameMode gameMode,
    required bool gameCompleted,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required int? lvlNumber,
    @Default({}) Set<String> eliminatedKeys,
  }) = GameWin;

  const factory failure({
    required Locale dictionary,
    required String secretWord,
    required GameMode gameMode,
    required bool gameCompleted,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required WordError error,
    required int? lvlNumber,
    @Default({}) Set<String> eliminatedKeys,
  }) = GameFailure;

  const factory persistenceFailure({
    required Locale dictionary,
    required String secretWord,
    required GameMode gameMode,
    required bool gameCompleted,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required int? lvlNumber,
    required GamePersistenceOperation operation,
    required GameResult pendingProgress,
    required GameResult? completedLevel,
    required bool? pendingIsWin,
    required int retryCount,
    @Default({}) Set<String> eliminatedKeys,
  }) = GamePersistenceFailure;

  int get currentWordIndex => (board.length - 1) ~/ 5;

  bool get isResult => this is GameWin || this is GameLoss;

  bool get isWin => this is GameWin;

  bool get isFailure => this is GameFailure || this is GamePersistenceFailure;

  bool get isPersistenceFailure => this is GamePersistenceFailure;

  bool get isInputBlocked => gameCompleted || isPersistenceFailure;

  bool isLetterEliminated(String letter) => eliminatedKeys.contains(letter);

  (bool, int, List<LetterInfo>)? get buildResultString {
    final bool? result = switch (this) {
      final GameWin _ => true,
      final GameLoss _ => false,
      _ => null,
    };
    if (result == null) {
      return null;
    }
    return (result, currentWordIndex + 1, board);
  }
}
