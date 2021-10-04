import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/mood.dart';

class DayEntriesRepository {
  Future<Iterable<DayEntry>> getAll() async {
    return [
      DayEntry(date: DateTime.now().add(const Duration(hours: -2)), mood: Mood.veryHappy),
      DayEntry(date: DateTime.now().add(const Duration(days: -1)), mood: Mood.happy),
      DayEntry(date: DateTime.now().add(const Duration(days: -2)), mood: Mood.sad),
    ];
  }
}