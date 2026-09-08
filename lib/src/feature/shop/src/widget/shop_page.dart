import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/coin.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/shop/shop.dart';
import 'package:wordly/src/feature/wallet/wallet.dart';

/// A shop to spend tokens on play field themes and avatars.
class const ShopPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletService wallet = WalletScope.of(context);
    final SettingsContainer settingsContainer = SettingsScope.of(context);
    return Title(
      color: Colors.black,
      title: context.l10n.shop,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.shop, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ValueListenableBuilder<WalletState>(
          valueListenable: wallet.notifier,
          builder: (context, state, _) {
            final String activeTheme = settingsContainer.settingsService.current.general.activeTheme ?? '';
            return ConstraintScreen(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(context.l10n.shopSubtitle, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.shopThemes.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final ShopThemeEntry entry in ShopCatalog.themes)
                      _ThemeListTile(
                        entry: entry,
                        owned: state.ownedItems.contains(entry.id),
                        active: activeTheme == entry.id,
                        onBuy: () async {
                          final bool ok = await wallet.purchaseItem(entry.id, entry.price);
                          if (!context.mounted) {
                            return;
                          }
                          _showResult(context, ok ? context.l10n.shopBought : context.l10n.notEnoughTokens, ok);
                          if (ok) {
                            await _applyTheme(context, entry.id);
                          }
                        },
                        onApply: () => _applyTheme(context, entry.id),
                      ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.shopAvatars.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final AvatarInfo avatar in ShopCatalog.avatars)
                      _AvatarListTile(
                        avatar: avatar,
                        owned: state.ownedItems.contains(avatar.id),
                        active: state.activeAvatar == avatar.id,
                        onBuy: () async {
                          final bool ok = await wallet.purchaseItem(avatar.id, avatar.price);
                          if (!context.mounted) {
                            return;
                          }
                          _showResult(context, ok ? context.l10n.shopBought : context.l10n.notEnoughTokens, ok);
                          if (ok) {
                            await _selectAvatar(context, avatar.id);
                          }
                        },
                        onApply: () => _selectAvatar(context, avatar.id),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _applyTheme(BuildContext context, String id) async {
    final SettingsContainer settingsContainer = SettingsScope.of(context);
    await settingsContainer.settingsService.update(
      (current) => current.copyWith(general: current.general.copyWith(activeTheme: id)),
    );
    if (!context.mounted) {
      return;
    }
    _showResult(context, context.l10n.themeApplied, true);
  }

  Future<void> _selectAvatar(BuildContext context, String id) async {
    final WalletService wallet = WalletScope.of(context);
    final bool ok = await wallet.setActiveAvatar(id);
    if (!context.mounted) {
      return;
    }
    _showResult(context, ok ? context.l10n.avatarApplied : context.l10n.notEnoughTokens, ok);
  }

  void _showResult(BuildContext context, String message, bool positive) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: positive ? null : Theme.of(context).colorScheme.error),
      );
  }
}

class const _ThemeListTile({
  required final ShopThemeEntry entry,
  required final bool owned,
  required final bool active,
  required final Future<void> Function() onBuy,
  required final VoidCallback onApply,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemePalette? palette = ThemesCatalog.byId(entry.id);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: palette == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final Color color in [palette.correct, palette.wrongSpot, palette.inactive])
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                ],
              ),
        title: Text(_themeName(context, entry.id)),
        subtitle: owned ? Text(active ? context.l10n.itemActive : context.l10n.itemOwned) : null,
        trailing: active
            ? Text(context.l10n.itemActive, style: const TextStyle(fontWeight: FontWeight.w700))
            : owned
            ? TextButton(onPressed: onApply, child: Text(context.l10n.itemOwned))
            : FilledButton.tonal(
                onPressed: onBuy,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('${entry.price}'), const SizedBox(width: 6), const Coin(size: 16)],
                ),
              ),
      ),
    );
  }
}

class const _AvatarListTile({
  required final AvatarInfo avatar,
  required final bool owned,
  required final bool active,
  required final Future<void> Function() onBuy,
  required final VoidCallback onApply,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatar.color,
          child: Icon(avatar.icon, color: Colors.white),
        ),
        title: Text(_avatarName(context, avatar.id)),
        subtitle: owned ? Text(active ? context.l10n.itemActive : context.l10n.itemOwned) : null,
        trailing: active
            ? Text(context.l10n.itemActive, style: const TextStyle(fontWeight: FontWeight.w700))
            : owned
            ? TextButton(onPressed: onApply, child: Text(context.l10n.itemOwned))
            : FilledButton.tonal(
                onPressed: onBuy,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('${avatar.price}'), const SizedBox(width: 6), const Coin(size: 16)],
                ),
              ),
      ),
    );
  }
}

String _themeName(BuildContext context, String id) => switch (id) {
  'ocean' => context.l10n.themeOcean,
  'forest' => context.l10n.themeForest,
  'sunset' => context.l10n.themeSunset,
  'midnight' => context.l10n.themeMidnight,
  _ => context.l10n.themeRoyal,
};

String _avatarName(BuildContext context, String id) => switch (id) {
  'fox' => context.l10n.avatarFox,
  'owl' => context.l10n.avatarOwl,
  _ => context.l10n.avatarTiger,
};
