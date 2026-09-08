import 'package:wordly/src/feature/wallet/src/data/datasources/wallet_datasource.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

final class WalletRepositoryImpl({required final WalletDatasource datasource}) implements WalletRepository {
  @override
  Future<WalletState> read() => datasource.read();

  @override
  Future<void> save(WalletState wallet) => datasource.write(wallet);
}
