import 'package:emobook/models/day_entry_view_model.dart';
import 'package:emobook/models/mood.dart';
import 'package:emobook/widgets/emo_mood_selector_widget.dart';
import 'package:emobook/widgets/emotions_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:emobook/repositories/day_entries_repository.dart';

import 'day_entry_edit_page_options.dart';

class DayEntryEditPage extends StatefulWidget {
  static const routeName = '/day_entry/edit';

  const DayEntryEditPage(
      {Key? key, required this.repository, required this.options})
      : super(key: key);

  final DayEntriesRepository repository;
  final DayEntryEditPageOptions options;

  @override
  State<DayEntryEditPage> createState() => _DayEntryEditPageState();
}

class _DayEntryEditPageState extends State<DayEntryEditPage> {
  late final DayEntryViewModel viewModel;

  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = widget.options.viewModel;
    _persistViewModel();
    _commentController.text = viewModel.comment ?? '';
    _commentController.addListener(_updateComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit entry'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomAppBar(
        child: EmoMoodSelectorWidget(
          onTap: _updateMood,
          currentMood: viewModel.mood,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        Text('My emotions'),
        const SizedBox(height: 8.0),
        EmotionsSelectorField(
          emotions: viewModel.emotions ?? [],
          onTap: () => _selectEmotions(context),
        ),
        const SizedBox(height: 8.0),
        Focus(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Comment'),
          ),
          onFocusChange: (gotFocus) {
            if (!gotFocus) {
              _persistViewModel();
            }
          },
        ),
      ]),
    );
  }

  void _updateMood({required Mood mood}) {
    setState(() => viewModel.mood = mood);
    _persistViewModel();
  }

  void _selectEmotions(BuildContext context) {}

  void _updateComment() {
    final text = _commentController.text;
    viewModel.comment = text;
  }

  Future<void> _persistViewModel() async {
    final id = await widget.repository
        .updateOrSaveEntry(viewModel.id, viewModel.entry);
    viewModel.id = id;
  }
}
