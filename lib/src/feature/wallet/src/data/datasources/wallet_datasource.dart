import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

final class const WalletDatasource({required final SharedPreferencesAsync preferences}) {
  static const String _key = 'wallet';

  Future<WalletState> read() async {
    final String? raw = await preferences.getString(_key);
    if (raw == null) {
      return const WalletState();
    }
    try {
      return const WalletCodec().decode(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return const WalletState();
    }
  }

  Future<void> write(WalletState wallet) async {
    await preferences.setString(_key, jsonEncode(const WalletCodec().encode(wallet)));
  }
}
