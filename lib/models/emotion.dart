import 'package:flutter/widgets.dart';

enum Emotion {
  grateful,
}

extension EmotionLocalization on Emotion {
  String localized(BuildContext context) {
    switch (this) {
      case Emotion.grateful: return 'grateful';
    }
  }
}

extension EmotionsListLocalization on Iterable<Emotion> {
  Iterable<String> localized(BuildContext context) {
    return map((e) => e.localized(context));
  }
}
