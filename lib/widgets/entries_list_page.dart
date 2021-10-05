import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/day_entry_view_model.dart';
import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/models/mood.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:emobook/widgets/day_entry_edit_page.dart';
import 'package:emobook/widgets/day_entry_list_item.dart';
import 'package:emobook/widgets/emo_list_header.dart';
import 'package:emobook/widgets/emo_mood_selector_widget.dart';
import 'package:emobook/widgets/snapshot_based_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'day_entry_edit_page_options.dart';
import 'package:emobook/extensions/date.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EntriesListPage extends StatefulWidget {
  const EntriesListPage({Key? key, required this.repository}) : super(key: key);

  final DayEntriesRepository repository;

  @override
  _EntriesListPageState createState() => _EntriesListPageState();
}

typedef _PageDataType = Iterable<DayEntry>;

class _EntriesListPageState extends State<EntriesListPage> {
  var _snapshot = const AsyncSnapshot<_PageDataType>.waiting();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotBasedScreen(snapshot: _snapshot, buildChild: _buildList);
  }

  Widget _buildList(BuildContext context, _PageDataType data) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.entriesListPage_title),
      ),
      body: ListView(
        children: _buildListItems(data).toList(growable: false),
      ),
      bottomNavigationBar: BottomAppBar(
        child: EmoMoodSelectorWidget(
          onTap: _navToNewEntry,
        ),
      ),
    );
  }

  Iterable<Widget> _buildListItems(Iterable<DayEntry> entries) sync* {
    DateTime? previousDay;
    for (final entry in entries) {
      final entryDate = entry.date.toLocal();
      if (previousDay?.isSameDate(entryDate) != true) {
        yield EmoListHeader.themeDefault(
            theme: EmoTheme.of(context),
            title: DateFormat.yMd(Localizations.localeOf(context).languageCode)
                .format(entryDate));
        previousDay = entryDate;
      }
      yield _buildListItem(entry);
    }
  }

  Widget _buildListItem(DayEntry entry) {
    return Dismissible(
      key: Key(entry.id ?? ''),
      child: DayEntryListItem(
          dayEntry: entry,
          onTap: () => _navToEditEntry(entry: entry),
      ),
      onDismissed: (direction) {
        if (direction != DismissDirection.endToStart) {
          return;
        }
        _deleteEntry(entry);
      },
      confirmDismiss: (direction) => _confirmDismiss(direction, context),
      direction: DismissDirection.endToStart,
      background: Container(
        color: EmoTheme.of(context).dismissDeleteBgColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.delete,
          color: EmoTheme.of(context).dismissDeleteFgColor,
        ),
      ),
    );
  }

  void _setSnapshot(AsyncSnapshot<_PageDataType> snapshot) {
    setState(() {
      _snapshot = snapshot;
    });
  }

  Future<bool> _confirmDismiss(DismissDirection direction, BuildContext context) async {
    final result = await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!
            .entriesListPage_deleteEntry_dialog_title),
        content: Text(AppLocalizations.of(context)!
            .entriesListPage_deleteEntry_dialog_content),
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
    });

    return result ?? false;
  }

  Future<void> _navToNewEntry({required Mood mood}) async {
    final options =
        DayEntryEditPageOptions(viewModel: DayEntryViewModel.withMood(mood));
    await Navigator.of(context)
        .pushNamed(DayEntryEditPage.routeName, arguments: options);
    _loadData();
  }

  Future<void> _navToEditEntry({required DayEntry entry}) async {
    final options = DayEntryEditPageOptions(
        viewModel: DayEntryViewModel.fromEntry(entry: entry));
    await Navigator.of(context)
        .pushNamed(DayEntryEditPage.routeName, arguments: options);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (!_snapshot.hasData) {
        _setSnapshot(const AsyncSnapshot.waiting());
      }
      final entries = await widget.repository.getAll();
      _setSnapshot(AsyncSnapshot.withData(ConnectionState.done, entries));
    } catch (e) {
      _setSnapshot(AsyncSnapshot.withError(ConnectionState.done, e));
    }
  }

  Future<void> _deleteEntry(DayEntry entry) async {
    final id = entry.id;
    if (id == null) {
      _removeEntryFromList(entry);
      return;
    }
    await widget.repository.removeEntry(id);
    _removeEntryFromList(entry);
  }

  void _removeEntryFromList(DayEntry entry) async {
    final data = _snapshot.data;
    if (data != null) {
      _setSnapshot(AsyncSnapshot.withData(
          ConnectionState.done, data.where((e) => e != entry)));
    }
  }
}
