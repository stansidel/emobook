import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/emo_file.dart';
import 'package:emobook/models/emotion.dart';
import 'package:emobook/widgets/emo_image_view.dart';
import 'package:emobook/widgets/mood_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:emobook/extensions/exists.dart';
import 'package:intl/intl.dart';

class DayEntryListItem extends StatelessWidget {
  const DayEntryListItem({Key? key, required this.dayEntry, this.onTap})
      : super(key: key);

  final DayEntry dayEntry;

  String get _comment => dayEntry.comment ?? '';

  EmoFile? get _image => dayEntry.images?.firstOrNull;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final emotions = dayEntry.emotions?.localized(context).join(', ') ?? '';
    return ListTile(
      leading: MoodWidget(mood: dayEntry.mood),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_localizedDate(dayEntry.date, context)),
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
      onTap: onTap,
    );
  }
}

String _localizedDate(DateTime date, BuildContext context) {
  return DateFormat.yMd(Localizations.localeOf(context).languageCode)
      .add_jm()
      .format(date.toLocal());
}
