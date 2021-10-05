import 'dart:developer';

import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/day_entry_view_model.dart';
import 'package:emobook/models/emo_file.dart';
import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/models/emotion.dart';
import 'package:emobook/models/mood.dart';
import 'package:emobook/widgets/drawing/drawing_page.dart';
import 'package:emobook/widgets/emo_image_view.dart';
import 'package:emobook/widgets/emo_mood_selector_widget.dart';
import 'package:emobook/widgets/emotions_selector_field.dart';
import 'package:emobook/widgets/select_emotions_page.dart';
import 'package:flutter/material.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'day_entry_edit_page_options.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.dayEntryEditPage_title),
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
        _buildDateField(context),
        const SizedBox(height: 8.0),
        Text(AppLocalizations.of(context)!
            .dayEntryEditPage_list_myEmotions_label),
        const SizedBox(height: 8.0),
        EmotionsSelectorField(
          emotions: viewModel.emotions ?? [],
          onTap: () => _selectEmotions(context),
        ),
        const SizedBox(height: 8.0),
        _buildCommentField(),
        const SizedBox(height: 8.0),
        _buildImagesWidgets(context),
        const SizedBox(height: 8.0),
        _buildAddImageButtons(),
      ]),
    );
  }

  Widget _buildDateField(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final formattedDate =
        DateFormat.yMd(locale).add_jm().format(viewModel.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(AppLocalizations.of(context)!
          .dayEntryEditPage_list_date_label(formattedDate)),
    );
  }

  Widget _buildCommentField() {
    return Focus(
      child: TextField(
        controller: _commentController,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!
                .dayEntryEditPage_list_comment_hintText),
      ),
      onFocusChange: (gotFocus) {
        if (!gotFocus) {
          _persistViewModel();
        }
      },
    );
  }

  Widget _buildImagesWidgets(BuildContext context) {
    final entry = viewModel.entry;
    return Column(
      children: viewModel.images
              ?.map((i) => _buildSingleImage(context, entry, i))
              .toList() ??
          [],
    );
  }

  Widget _buildSingleImage(
      BuildContext context, DayEntry entry, EmoFile image) {
    return Dismissible(
      key: Key(image.path),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => _onImageDismiss(direction, entry, image),
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: EmoTheme.of(context).dismissDeleteBgColor,
        ),
        child: Icon(
          Icons.delete,
          color: EmoTheme.of(context).dismissDeleteFgColor,
        ),
      ),
      child: ClipRRect(
        child: EmoImageView(image: image),
        borderRadius: BorderRadius.circular(28.0),
      ),
    );
  }

  Future<void> _onImageDismiss(
      DismissDirection direction, DayEntry entry, EmoFile image) async {
    if (direction != DismissDirection.endToStart) {
      return;
    }
    final newEntry =
        await widget.repository.removeImage(entry: entry, image: image);
    setState(() {
      viewModel.images = newEntry.images;
    });
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .dayEntryEditPage_deleteImage_dialog_title),
          content: Text(AppLocalizations.of(context)!
              .dayEntryEditPage_deleteImage_dialog_content),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.general_button_yes),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.general_button_no),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Widget _buildAddImageButtons() {
    return Wrap(
      children: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!
                .dayEntryEditPage_list_imageButtons_fromGallery,
          ),
          onPressed: () => _addImage(ImageSource.gallery),
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!
                .dayEntryEditPage_list_imageButtons_camera,
          ),
          onPressed: () => _addImage(ImageSource.camera),
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!
                .dayEntryEditPage_list_imageButtons_doodle,
          ),
          onPressed: () => _addDrawing(context),
        ),
      ],
    );
  }

  Future<void> _addDrawing(BuildContext context) async {
    final image = await Navigator.of(context).pushNamed(DrawingPage.routeName);
    if (image is! DrawingPageImageData) {
      return;
    }
    try {
      final newEntry = await widget.repository.addImageFromBytes(
          entry: viewModel.entry,
          bytes: image.data,
          extension: image.extension);
      setState(() {
        viewModel.images = newEntry.images;
      });
    } catch (e) {
      log('Unexpected error while saving file: $e');
      var snackBar = SnackBar(
          content:
              Text(AppLocalizations.of(context)!.general_error_unexpected));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
      var snackBar = SnackBar(
          content:
              Text(AppLocalizations.of(context)!.general_error_unexpected));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _updateMood({required Mood mood}) {
    setState(() => viewModel.mood = mood);
    _persistViewModel();
  }

  Future<void> _selectEmotions(BuildContext context) async {
    var updatedEmotions = await Navigator.pushNamed(
        context, SelectEmotionsPage.routeName,
        arguments: viewModel.emotions ?? <Emotion>[]);
    if (updatedEmotions is! List<Emotion>) {
      return;
    }
    setState(() => viewModel.emotions = updatedEmotions);
    _persistViewModel();
  }

  void _updateComment() {
    final text = _commentController.text;
    viewModel.comment = text;
  }

  Future<void> _persistViewModel() async {
    final id = await widget.repository.updateOrSaveEntry(viewModel.entry);
    viewModel.id = id;
  }
}
