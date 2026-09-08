import 'package:flutter/widgets.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

/// A scope that provides the [WalletService] to its widget subtree.
class const WalletScope({
  /// The wallet service.
  required final WalletService walletService,
  required super.child,
  super.key,
}) extends InheritedWidget {
  /// Get the wallet service from the [context].
  static WalletService of(BuildContext context) => context.inhOf<WalletScope>(listen: false).walletService;

  @override
  bool updateShouldNotify(covariant WalletScope oldWidget) => !identical(walletService, oldWidget.walletService);
}
