import 'package:emobook/models/emo_file.dart';
import 'package:emobook/models/emotion.dart';

import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/mood.dart';

class DayEntryViewModel {
  String? id;
  DateTime date;
  Mood mood;
  String? comment;
  List<Emotion>? emotions;
  List<EmoFile>? images;

  DayEntryViewModel(
      {required this.date,
      required this.mood,
      required this.id,
      this.comment,
      this.emotions,
      this.images});

  static DayEntryViewModel fromEntry({required DayEntry entry}) {
    return DayEntryViewModel(
        date: entry.date,
        mood: entry.mood,
        id: entry.id,
        comment: entry.comment,
        emotions: entry.emotions,
        images: entry.images);
  }

  static DayEntryViewModel withMood(Mood mood) {
    return DayEntryViewModel(date: DateTime.now(), mood: mood, id: null);
  }

  DayEntry get entry {
    return DayEntry(
        id: id,
        date: date,
        mood: mood,
        comment: comment,
        emotions: emotions,
        images: images);
  }
}
