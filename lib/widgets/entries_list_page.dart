import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/day_entry_view_model.dart';
import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/models/mood.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:emobook/widgets/day_entry_edit_page.dart';
import 'package:emobook/widgets/day_entry_list_item.dart';
import 'package:emobook/widgets/emo_mood_selector_widget.dart';
import 'package:emobook/widgets/snapshot_based_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'day_entry_edit_page_options.dart';

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
        title: const Text('Entries'),
      ),
      body: ListView(
        children: [
          for (final entry in data) _buildListItem(entry),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: EmoMoodSelectorWidget(
          onTap: _navToNewEntry,
        ),
      ),
    );
  }

  Widget _buildListItem(DayEntry entry) {
    return GestureDetector(
      child: Dismissible(
        key: Key(entry.id ?? ''),
        child: DayEntryListItem(dayEntry: entry),
        onDismissed: (direction) {
          if (direction != DismissDirection.endToStart) {
            return;
          }
          _deleteEntry(entry);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: EmoTheme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.delete,
            color: EmoTheme.of(context).onErrorColor,
          ),
        ),
      ),
      onTap: () => _navToEditEntry(entry: entry),
    );
  }

  void _setSnapshot(AsyncSnapshot<_PageDataType> snapshot) {
    setState(() {
      _snapshot = snapshot;
    });
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
