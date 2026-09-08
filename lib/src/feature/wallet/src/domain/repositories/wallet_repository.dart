import 'package:wordly/src/feature/wallet/wallet.dart';

abstract interface class WalletRepository() {
  Future<WalletState> read();

  Future<void> save(WalletState wallet);
}
