import 'package:emobook/models/mood.dart';
import 'package:emobook/widgets/mood_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef EmoMoodOnSelect = void Function({required Mood mood});

class EmoMoodSelectorWidget extends StatelessWidget {
  const EmoMoodSelectorWidget({Key? key, this.onTap, this.currentMood})
      : super(key: key);

  final EmoMoodOnSelect? onTap;
  final Mood? currentMood;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moods.map((m) => _buildMoodWidget(context, m)).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _getLocalizedHint(context),
              style:
                  Theme.of(context).textTheme.caption?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedHint(BuildContext context) {
    if (currentMood == null) {
      return AppLocalizations.of(context)!.emoMoodSelectorWidget_hint_new;
    }
    return AppLocalizations.of(context)!.emoMoodSelectorWidget_hint_change;
  }

  Widget _buildMoodWidget(BuildContext context, Mood mood) {
    const size = 50.0;
    final isGrayscale = currentMood != null && currentMood != mood;
    return InkWell(
      onDoubleTap: () => onTap?.call(mood: mood),
      child: MoodWidget(mood: mood, width: size, greyscale: isGrayscale),
    );
  }
}

const Iterable<Mood> _moods = [
  Mood.verySad,
  Mood.sad,
  Mood.neutral,
  Mood.happy,
  Mood.veryHappy,
];
