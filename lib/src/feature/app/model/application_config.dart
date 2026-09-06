import 'package:wordly/src/feature/app/model/environment.dart';

/// Application configuration
class const ApplicationConfig() {
  /// Creates a new [ApplicationConfig] instance.
  this;

  /// The current environment.
  Environment get environment {
    String env = const String.fromEnvironment('ENVIRONMENT').trim();

    if (env.isNotEmpty) {
      return Environment.from(env);
    }

    env = const String.fromEnvironment('FLUTTER_APP_FLAVOR').trim();

    return Environment.from(env);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN').trim();

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;

  String get mySite => 'https://github.com/grandelagbanou28-gif/Lexora';

  String get email => 'grandelagbanou28@gmail.com';

  String get webLink => 'https://lexora-neon-one.vercel.app/';

  String get androidLink => 'https://grandelagbanou28-gif.github.io/Lexora/';
}
