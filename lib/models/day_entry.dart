import 'package:freezed_annotation/freezed_annotation.dart';
import 'emo_file.dart';
import 'emotion.dart';
import 'mood.dart';

part 'day_entry.freezed.dart';

@freezed
class DayEntry with _$DayEntry {
  const factory DayEntry({
    required DateTime date,
    required Mood mood,
    String? comment,
    List<Emotion>? emotions,
    List<EmoFile>? images,
  }) = _DayEntry;

  const DayEntry._();
}
