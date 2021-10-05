import 'dart:developer';

import 'package:emobook/models/day_entry_view_model.dart';
import 'package:emobook/models/emo_file.dart';
import 'package:emobook/models/mood.dart';
import 'package:emobook/widgets/emo_image_view.dart';
import 'package:emobook/widgets/emo_mood_selector_widget.dart';
import 'package:emobook/widgets/emotions_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:image_picker/image_picker.dart';

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
        _buildCommentField(),
        const SizedBox(height: 8.0),
        _buildImagesWidgets(),
        const SizedBox(height: 8.0),
        _buildAddImageButtons(),
      ]),
    );
  }

  Widget _buildCommentField() {
    return Focus(
      child: TextField(
        controller: _commentController,
        decoration: InputDecoration(hintText: 'Comment'),
      ),
      onFocusChange: (gotFocus) {
        if (!gotFocus) {
          _persistViewModel();
        }
      },
    );
  }

  Widget _buildImagesWidgets() {
    return Column(
      children:
          viewModel.images?.map((i) => _buildSingleImage(i)).toList() ?? [],
    );
  }

  Widget _buildSingleImage(EmoFile image) {
    return ClipRRect(
      child: EmoImageView(image: image),
      borderRadius: BorderRadius.circular(28.0),
    );
  }

  Widget _buildAddImageButtons() {
    return Row(
      children: [
        TextButton(
          child: Text('Add from Gallery'),
          onPressed: () => _addImage(ImageSource.gallery),
        ),
        TextButton(
          child: Text('Take photo'),
          onPressed: () => _addImage(ImageSource.camera),
        ),
      ],
    );
  }

  Future<void> _addImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    try {
      final newEntry = await widget.repository
          .addImage(entry: viewModel.entry, imagePath: pickedFile.path);
      setState(() {
        viewModel.images = newEntry.images;
      });
    } catch (e) {
      log('Unexpected error while saving file: $e');
      const snackBar = SnackBar(content: Text('Unexpected error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
    final id = await widget.repository.updateOrSaveEntry(viewModel.entry);
    viewModel.id = id;
  }
}
