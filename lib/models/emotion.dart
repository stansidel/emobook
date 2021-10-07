import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Emotion {
  grateful,

  // Happy
  ecstatic,
  energetic,
  aroused,
  bouncy,
  perky,
  antsy,

  // Excited
  fulfilled,
  contented,
  glad,
  complete,
  satisfied,
  optimistic,
  pleased,

  // Tender
  intimate,
  loving,
  warmHearted,
  sympathetic,
  touched,
  kind,
  soft,

  // Scared
  tense,
  nervous,
  anxious,
  jittery,
  frightened,
  panicStricken,
  terrified,

  // Angry
  irritated,
  resentful,
  miffed,
  upset,
  mad,
  furious,
  raging,

  // Sad
  down,
  blue,
  mopey,
  grieved,
  dejected,
  depressed,
  heartbroken,
}

extension EmotionLocalization on Emotion {
  String localized(BuildContext context) {
    switch (this) {
      case Emotion.grateful:
        return AppLocalizations.of(context)!.emotion_name_grateful;
      case Emotion.ecstatic:
        return AppLocalizations.of(context)!.emotion_name_ecstatic;
      case Emotion.energetic:
        return AppLocalizations.of(context)!.emotion_name_energetic;
      case Emotion.aroused:
        return AppLocalizations.of(context)!.emotion_name_aroused;
      case Emotion.bouncy:
        return AppLocalizations.of(context)!.emotion_name_bouncy;
      case Emotion.perky:
        return AppLocalizations.of(context)!.emotion_name_perky;
      case Emotion.antsy:
        return AppLocalizations.of(context)!.emotion_name_antsy;
      case Emotion.fulfilled:
        return AppLocalizations.of(context)!.emotion_name_fulfilled;
      case Emotion.contented:
        return AppLocalizations.of(context)!.emotion_name_contented;
      case Emotion.glad:
        return AppLocalizations.of(context)!.emotion_name_glad;
      case Emotion.complete:
        return AppLocalizations.of(context)!.emotion_name_complete;
      case Emotion.satisfied:
        return AppLocalizations.of(context)!.emotion_name_satisfied;
      case Emotion.optimistic:
        return AppLocalizations.of(context)!.emotion_name_optimistic;
      case Emotion.pleased:
        return AppLocalizations.of(context)!.emotion_name_pleased;
      case Emotion.intimate:
        return AppLocalizations.of(context)!.emotion_name_intimate;
      case Emotion.loving:
        return AppLocalizations.of(context)!.emotion_name_loving;
      case Emotion.warmHearted:
        return AppLocalizations.of(context)!.emotion_name_warmHearted;
      case Emotion.sympathetic:
        return AppLocalizations.of(context)!.emotion_name_sympathetic;
      case Emotion.touched:
        return AppLocalizations.of(context)!.emotion_name_touched;
      case Emotion.kind:
        return AppLocalizations.of(context)!.emotion_name_kind;
      case Emotion.soft:
        return AppLocalizations.of(context)!.emotion_name_soft;
      case Emotion.tense:
        return AppLocalizations.of(context)!.emotion_name_tense;
      case Emotion.nervous:
        return AppLocalizations.of(context)!.emotion_name_nervous;
      case Emotion.anxious:
        return AppLocalizations.of(context)!.emotion_name_anxious;
      case Emotion.jittery:
        return AppLocalizations.of(context)!.emotion_name_jittery;
      case Emotion.frightened:
        return AppLocalizations.of(context)!.emotion_name_frightened;
      case Emotion.panicStricken:
        return AppLocalizations.of(context)!.emotion_name_panicStricken;
      case Emotion.terrified:
        return AppLocalizations.of(context)!.emotion_name_terrified;
      case Emotion.irritated:
        return AppLocalizations.of(context)!.emotion_name_irritated;
      case Emotion.resentful:
        return AppLocalizations.of(context)!.emotion_name_resentful;
      case Emotion.miffed:
        return AppLocalizations.of(context)!.emotion_name_miffed;
      case Emotion.upset:
        return AppLocalizations.of(context)!.emotion_name_upset;
      case Emotion.mad:
        return AppLocalizations.of(context)!.emotion_name_mad;
      case Emotion.furious:
        return AppLocalizations.of(context)!.emotion_name_furious;
      case Emotion.raging:
        return AppLocalizations.of(context)!.emotion_name_raging;
      case Emotion.down:
        return AppLocalizations.of(context)!.emotion_name_down;
      case Emotion.blue:
        return AppLocalizations.of(context)!.emotion_name_blue;
      case Emotion.mopey:
        return AppLocalizations.of(context)!.emotion_name_mopey;
      case Emotion.grieved:
        return AppLocalizations.of(context)!.emotion_name_grieved;
      case Emotion.dejected:
        return AppLocalizations.of(context)!.emotion_name_dejected;
      case Emotion.depressed:
        return AppLocalizations.of(context)!.emotion_name_depressed;
      case Emotion.heartbroken:
        return AppLocalizations.of(context)!.emotion_name_heartbroken;
    }
  }
}

extension EmotionsListLocalization on Iterable<Emotion> {
  Iterable<String> localized(BuildContext context) {
    return map((e) => e.localized(context));
  }
}
