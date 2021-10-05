import 'package:flutter/widgets.dart';

enum Emotion {
  grateful,
}

extension EmotionLocalization on Iterable<Emotion> {
  Iterable<String> localized(BuildContext context) {
    return map((e) => _localizedEmotion(e, context));
  }
}

String _localizedEmotion(Emotion emotion, BuildContext context) {
  switch (emotion) {
    case Emotion.grateful: return 'Grateful';
  }
}
