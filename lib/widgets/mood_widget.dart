import 'package:emobook/gen/assets.gen.dart';
import 'package:emobook/models/mood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodWidget extends StatelessWidget {
  const MoodWidget({Key? key, required this.mood}) : super(key: key);

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return _svgPicture;
  }

  SvgPicture get _svgPicture {
    switch (mood) {
      case Mood.veryHappy: return SvgPicture.asset(Assets.images.moodVeryHappy);
      case Mood.happy: return SvgPicture.asset(Assets.images.moodHappy);
      case Mood.neutral: return SvgPicture.asset(Assets.images.moodNeutral);
      case Mood.sad: return SvgPicture.asset(Assets.images.moodSad);
      case Mood.verySad: return SvgPicture.asset(Assets.images.moodVerySad);
    }
  }
}
