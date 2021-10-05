import 'package:freezed_annotation/freezed_annotation.dart';
import 'emo_file.dart';
import 'emotion.dart';
import 'mood.dart';

part 'day_entry.freezed.dart';
part 'day_entry.g.dart';

@freezed
class DayEntry with _$DayEntry {
  const factory DayEntry({
    String? id,
    required DateTime date,
    required Mood mood,
    String? comment,
    List<Emotion>? emotions,
    List<EmoFile>? images,
  }) = _DayEntry;

  const DayEntry._();

  factory DayEntry.fromJson(Map<String, dynamic> json) => _$DayEntryFromJson(json);
}
