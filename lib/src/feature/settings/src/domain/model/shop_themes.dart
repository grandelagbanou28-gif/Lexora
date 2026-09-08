import 'package:flutter/material.dart';

/// A play field color palette for a purchasable theme.
@immutable
final class const ThemePalette({
  required final String id,
  required final Color correct,
  required final Color wrongSpot,
  required final Color inactive,
  required final Color inactiveDark,
});

/// Available play field color themes.
final class const ThemesCatalog() {
  static const List<ThemePalette> all = [
    ThemePalette(
      id: 'ocean',
      correct: Color(0xFF0E9594),
      wrongSpot: Color(0xFF4F86C6),
      inactive: Color(0xFFB2D8D8),
      inactiveDark: Color(0xFF3E6B75),
    ),
    ThemePalette(
      id: 'forest',
      correct: Color(0xFF3A7D44),
      wrongSpot: Color(0xFFC9A227),
      inactive: Color(0xFFB5CFA3),
      inactiveDark: Color(0xFF557052),
    ),
    ThemePalette(
      id: 'sunset',
      correct: Color(0xFFD15B3B),
      wrongSpot: Color(0xFFE0A526),
      inactive: Color(0xFFF2C9A8),
      inactiveDark: Color(0xFF8A5A43),
    ),
    ThemePalette(
      id: 'midnight',
      correct: Color(0xFF6C5CE7),
      wrongSpot: Color(0xFF2A9D8F),
      inactive: Color(0xFF9E9ADB),
      inactiveDark: Color(0xFF4A4666),
    ),
    ThemePalette(
      id: 'royal',
      correct: Color(0xFFC9A227),
      wrongSpot: Color(0xFF9D5C63),
      inactive: Color(0xFFE4C9A0),
      inactiveDark: Color(0xFF6E5B45),
    ),
  ];

  static ThemePalette? byId(String? id) {
    if (id == null) {
      return null;
    }
    for (final ThemePalette palette in all) {
      if (palette.id == id) {
        return palette;
      }
    }
    return null;
  }
}
