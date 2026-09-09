import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';

class const HaveNotPlayed({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_view_rounded, size: 64, color: colors.outline),
            const SizedBox(height: 16),
            Text(
              context.l10n.notPlayed,
              style: context.theme.textTheme.titleMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
