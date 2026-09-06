import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';

class const AboutPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: context.l10n.about,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.about, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ConstraintScreen(
          child: Column(
            children: [
              const Spacer(),
              Text(
                context.l10n.appTitle,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              SelectableText(
                'FR · FƆNGBÈ · EN · RU',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.appDictionary,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(flex: 10),
              _MailToContact(
                contact: context.l10n.contact,
                email: const ApplicationConfig().email,
              ),
              const Spacer(),
              const _CreditNameText(
                text: 'Lexora · Based on Wordly Plus by Roman Laptev (Carapacik)',
                url: 'https://carapacik.github.io',
              ),
              const SizedBox(height: 16),
              Text(
                context.dependencies.packageInfo.version,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class const _MailToContact({required final String contact, required final String email}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse('mailto:$email?${context.l10n.sendMessage}'),
      builder: (context, followLink) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: followLink,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: contact),
                WidgetSpan(
                  child: SelectableText(
                    email,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _CreditNameText({required final String text, required final String url}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Link(
    uri: Uri.parse(url),
    builder: (context, followLink) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: followLink,
        behavior: HitTestBehavior.opaque,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}