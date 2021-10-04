import 'package:emobook/models/mood.dart';
import 'package:flutter/material.dart';

class MoodWidget extends StatelessWidget {
  const MoodWidget({Key? key, required this.mood}) : super(key: key);

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Text(_text);
  }

  String get _text {
    switch (mood) {
      case Mood.veryHappy: return 'Very happy';
      case Mood.happy: return 'Happy';
      case Mood.neutral: return 'Neutral';
      case Mood.sad: return 'Sad';
      case Mood.verySad: return 'Very sad';
    }
  }
}
