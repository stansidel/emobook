import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/emo_file.dart';
import 'package:emobook/models/emotion.dart';
import 'package:emobook/widgets/emo_image_view.dart';
import 'package:emobook/widgets/mood_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:emobook/extensions/exists.dart';

class DayEntryListItem extends StatelessWidget {
  const DayEntryListItem({Key? key, required this.dayEntry}) : super(key: key);

  final DayEntry dayEntry;

  String get _comment => dayEntry.comment ?? '';

  EmoFile? get _image => dayEntry.images?.firstOrNull;

  @override
  Widget build(BuildContext context) {
    final emotions = dayEntry.emotions?.localized(context).join(', ') ?? '';
    return ListTile(
      leading: MoodWidget(mood: dayEntry.mood),
      title: Column(
        children: [
          Text(dayEntry.date.toIso8601String()),
          if (_comment.isNotEmpty)
            Text(
              _comment,
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (emotions.isNotEmpty) Text(emotions),
        ],
      ),
      trailing: _image.exists((i) => EmoImageView(image: i)),
    );
  }
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
