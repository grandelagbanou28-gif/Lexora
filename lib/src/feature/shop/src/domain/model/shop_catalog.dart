import 'package:flutter/material.dart';

/// A purchasable play field theme.
@immutable
final class const ShopThemeEntry({required final String id, required final int price});

/// A purchasable avatar.
@immutable
final class const AvatarInfo({
  required final String id,
  required final IconData icon,
  required final Color color,
  required final int price,
});

/// Static catalog of purchasable themes and avatars.
final class const ShopCatalog() {
  static const List<ShopThemeEntry> themes = [
    ShopThemeEntry(id: 'ocean', price: 100),
    ShopThemeEntry(id: 'forest', price: 150),
    ShopThemeEntry(id: 'sunset', price: 150),
    ShopThemeEntry(id: 'midnight', price: 200),
    ShopThemeEntry(id: 'royal', price: 250),
  ];

  static const List<AvatarInfo> avatars = [
    AvatarInfo(id: 'fox', icon: Icons.pets, color: Color(0xFFE07B39), price: 80),
    AvatarInfo(id: 'owl', icon: Icons.auto_stories, color: Color(0xFF7E57C2), price: 100),
    AvatarInfo(id: 'tiger', icon: Icons.whatshot, color: Color(0xFFE0A526), price: 120),
  ];

  static ShopThemeEntry? themeById(String id) {
    for (final ShopThemeEntry entry in themes) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  static AvatarInfo? avatarById(String id) {
    for (final AvatarInfo entry in avatars) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }
}
