import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/generated/fonts.gen.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/app/widget/media_query_override.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/settings/settings.dart';

/// Entry point for the application that uses [MaterialApp].
class const MaterialContext({super.key}) extends StatefulWidget {
  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState() extends State<MaterialContext> {
  /// This global key is needed for Flutter to work properly
  /// when Widgets Inspector is enabled.
  static final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) {
        final ThemeModeVO themeMode = settings.general.themeMode;
        final ColorMode colorMode = settings.general.colorMode;
        final (Color, Color, Color)? otherColors = settings.general.otherColors;
        final Locale locale = settings.general.locale;

        final ThemeMode materialThemeMode = themeMode.toMaterialThemeMode();
        final Color seedColor = colorMode == ColorMode.other ? otherColors?.$1 ?? AppColors.green : AppColors.green;

        final ThemeData darkTheme = _buildTheme(
          brightness: Brightness.dark,
          background: AppColors.darkBackground,
          appBarColor: AppColors.darkBackground,
          seedColor: seedColor,
        );
        final ThemeData lightTheme = _buildTheme(
          brightness: Brightness.light,
          background: Colors.white,
          appBarColor: Colors.white,
          seedColor: seedColor,
        );
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: materialThemeMode,
          localizationsDelegates: Localization.localizationDelegates,
          supportedLocales: Localization.supportedLocales,
          locale: locale,
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          home: const GamePage(),
          builder: (context, child) => KeyedSubtree(
            key: _globalKey,
            child: MediaQueryRootOverride(child: child!),
          ),
        );
      },
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color appBarColor,
    required Color seedColor,
  }) {
    final scheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
    final base = ThemeData(colorScheme: scheme, brightness: brightness, fontFamily: FontFamily.nunito);
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 14),
        labelLarge: base.textTheme.labelLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      extensions: [BackgroundCustomColors(background: background)],
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: base.filledButtonTheme.style?.copyWith(
          textStyle: WidgetStatePropertyAll(base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: base.outlinedButtonTheme.style?.copyWith(
          textStyle: WidgetStatePropertyAll(base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          side: WidgetStatePropertyAll(BorderSide(color: scheme.outlineVariant)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: base.textButtonTheme.style?.copyWith(
          textStyle: WidgetStatePropertyAll(base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      dividerTheme: base.dividerTheme.copyWith(color: scheme.outlineVariant, thickness: 1),
      navigationDrawerTheme: base.navigationDrawerTheme.copyWith(indicatorColor: scheme.primaryContainer),
    );
  }
}
