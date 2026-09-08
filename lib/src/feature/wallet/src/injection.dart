import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/wallet/src/application/wallet_service.dart';
import 'package:wordly/src/feature/wallet/src/data/datasources/wallet_datasource.dart';
import 'package:wordly/src/feature/wallet/src/data/repositories/wallet_repository_impl.dart';

/// Container with wallet (tokens, xp, badges) state.
class const WalletContainer._(
  /// Service for managing the player wallet.
  final WalletService walletService,
) {
  /// Create a new [WalletContainer] with the given [sharedPreferences].
  static Future<WalletContainer> create({required SharedPreferencesAsync sharedPreferences}) async {
    final walletRepository = WalletRepositoryImpl(
      datasource: WalletDatasource(preferences: sharedPreferences),
    );

    final WalletService walletService = await WalletService.create(repository: walletRepository);

    return WalletContainer._(walletService);
  }
}
