import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/about/widget/about_page.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/league/league.dart';
import 'package:wordly/src/feature/profile/profile.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/coin.dart';
import 'package:wordly/src/feature/shop/shop.dart';
import 'package:wordly/src/feature/tutorial/widget/tutorial_page.dart';

class const CustomDrawer({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  'L',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(context.l10n.appTitle, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const Divider(height: 1),
        ListTile(
          title: Text(context.l10n.daily, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>()..add(const GameEvent.changeGameMode(GameMode.daily));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.levels, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>()..add(const GameEvent.changeGameMode(GameMode.lvl));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.practiceMode, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>()..add(const GameEvent.changeGameMode(GameMode.practice));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.friendMode, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            final String? code = await _promptFriendCode(context);
            if (code == null) {
              return;
            }
            bloc.add(GameEvent.startFriendGame(code));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.tutorial, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute<void>(builder: (context) => const TutorialPage(), fullscreenDialog: true),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.profile, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            await navigator.push(
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider.value(value: bloc, child: const ProfilePage()),
              ),
            );
          },
        ),
        ListTile(
          leading: const Coin(size: 18),
          title: Text(context.l10n.shop, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            await navigator.push(
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider.value(value: bloc, child: const ShopPage()),
              ),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.league, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            await navigator.push(
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider.value(value: bloc, child: const LeaguePage()),
              ),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.settings, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            await navigator.push(
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider.value(value: bloc, child: const SettingsPage()),
              ),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.about, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute<void>(builder: (context) => const AboutPage(), fullscreenDialog: true),
            );
          },
        ),
      ],
    );
  }

  Future<String?> _promptFriendCode(BuildContext context) => showDialog<String>(
    context: context,
    builder: (context) {
      final controller = TextEditingController();
      return AlertDialog(
        title: Text(context.l10n.friendMode),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'AB12CD', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(context.l10n.start),
          ),
        ],
      );
    },
  );
}
