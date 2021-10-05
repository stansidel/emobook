import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Emotion {
  grateful,
}

extension EmotionLocalization on Emotion {
  String localized(BuildContext context) {
    switch (this) {
      case Emotion.grateful:
        return AppLocalizations.of(context)!.emotion_name_grateful;
    }
  }
}

extension EmotionsListLocalization on Iterable<Emotion> {
  Iterable<String> localized(BuildContext context) {
    return map((e) => e.localized(context));
  }
}
