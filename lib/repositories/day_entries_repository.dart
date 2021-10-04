import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/emotion.dart';
import 'package:emobook/models/mood.dart';

class DayEntriesRepository {
  Future<Iterable<DayEntry>> getAll() async {
    return [
      DayEntry(date: DateTime.now().add(const Duration(hours: -2)), mood: Mood.veryHappy),
      DayEntry(date: DateTime.now().add(const Duration(days: -1)), mood: Mood.happy, comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Enim etiam cursus tincidunt in scelerisque rhoncus cras in habitasse. Bibendum volutpat at faucibus facilisi at. Augue vel ullamcorper ridiculus in ullamcorper pellentesque. Odio gravida aliquam aliquet odio orci vitae pretium. Et ultrices id lobortis mi euismod quis porttitor mauris praesent.'),
      DayEntry(date: DateTime.now().add(const Duration(days: -2)), mood: Mood.sad, comment: 'Something sad happened', emotions: [Emotion.grateful]),
    ];
  }
}
