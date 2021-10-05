import 'package:emobook/models/mood.dart';
import 'package:emobook/widgets/mood_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef EmoMoodOnSelect = void Function({required Mood mood});

class EmoMoodSelectorWidget extends StatelessWidget {
  const EmoMoodSelectorWidget({Key? key, this.onTap}) : super(key: key);

  final EmoMoodOnSelect? onTap;

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
              'Double tap to track your emotion',
              style:
              Theme
                  .of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodWidget(BuildContext context, Mood mood) {
    const size = 50.0;
    // return Stack(
    //   children: [
    //     MoodWidget(mood: mood, width: size),
    //     Material(
    //       color: Colors.transparent,
    //       child: InkWell(
    //         onDoubleTap: () => onTap?.call(mood: mood),
    //         borderRadius: BorderRadius.circular(size / 2),
    //         child: Container(
    //           width: size,
    //           height: size,
    //           decoration: const BoxDecoration(
    //             shape: BoxShape.circle,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
    return InkWell(
      onDoubleTap: () => onTap?.call(mood: mood),
      child: MoodWidget(mood: mood, width: size),
    );
  }
}

const Iterable<Mood> _moods = [
  Mood.veryHappy,
  Mood.happy,
  Mood.neutral,
  Mood.sad,
  Mood.verySad
];
