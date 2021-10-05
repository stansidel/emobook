import 'package:emobook/gen/assets.gen.dart';
import 'package:emobook/models/mood.dart';
import 'package:flutter/material.dart';

class MoodWidget extends StatelessWidget {
  const MoodWidget(
      {Key? key, required this.mood, this.width = 50, this.greyscale = false})
      : super(key: key);

  final Mood mood;
  final double width;
  final bool greyscale;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _pictureName.assetName,
      width: width,
      height: width,
    );
  }

  AssetGenImage get _pictureName {
    switch (mood) {
      case Mood.veryHappy:
        return greyscale ? Assets.images.moodVeryHappyGrey : Assets.images.moodVeryHappy;
      case Mood.happy:
        return greyscale ? Assets.images.moodHappyGrey : Assets.images.moodHappy;
      case Mood.neutral:
        return greyscale ? Assets.images.moodNeutralGrey : Assets.images.moodNeutral;
      case Mood.sad:
        return greyscale ? Assets.images.moodSadGrey : Assets.images.moodSad;
      case Mood.verySad:
        return greyscale ? Assets.images.moodVerySadGrey : Assets.images.moodVerySad;
    }
  }
}
