import 'package:emobook/models/day_entry.dart';
import 'package:emobook/widgets/mood_widget.dart';
import 'package:flutter/material.dart';

class DayEntryListItem extends StatelessWidget {
  const DayEntryListItem({Key? key, required this.dayEntry}) : super(key: key);

  final DayEntry dayEntry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: MoodWidget(mood: dayEntry.mood),

    );
  }
}
