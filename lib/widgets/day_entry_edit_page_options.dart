import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:emobook/models/day_entry_view_model.dart';

part 'day_entry_edit_page_options.freezed.dart';

@freezed
class DayEntryEditPageOptions with _$DayEntryEditPageOptions {
  const factory DayEntryEditPageOptions({
    required DayEntryViewModel viewModel,
  }) = _DayEntryEditPageOptions;
}
