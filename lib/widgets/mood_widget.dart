import 'package:emobook/gen/assets.gen.dart';
import 'package:emobook/models/mood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodWidget extends StatelessWidget {
  const MoodWidget({Key? key, required this.mood, this.width = 50})
      : super(key: key);

  final Mood mood;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _pictureName,
      width: width,
      height: width,
      fit: BoxFit.contain,
    );
  }

  String get _pictureName {
    switch (mood) {
      case Mood.veryHappy:
        return Assets.images.moodVeryHappy;
      case Mood.happy:
        return Assets.images.moodHappy;
      case Mood.neutral:
        return Assets.images.moodNeutral;
      case Mood.sad:
        return Assets.images.moodSad;
      case Mood.verySad:
        return Assets.images.moodVerySad;
    }
  }
}
