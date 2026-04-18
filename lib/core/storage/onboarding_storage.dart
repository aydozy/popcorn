import 'package:hive/hive.dart';

import '../constants/app_constants.dart';

class OnboardingStorage {
  static const String _key = 'has_seen_onboarding';

  bool hasSeen() =>
      Hive.box(settingsBox).get(_key, defaultValue: false) as bool;

  Future<void> markSeen() => Hive.box(settingsBox).put(_key, true);
}
