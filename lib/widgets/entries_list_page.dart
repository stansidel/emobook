import 'package:emobook/models/day_entry.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:emobook/widgets/day_entry_list_item.dart';
import 'package:emobook/widgets/snapshot_based_screen.dart';
import 'package:flutter/material.dart';

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
          for (final entry in data) DayEntryListItem(dayEntry: entry),
        ],
      ),
    );
  }

  void _setSnapshot(AsyncSnapshot<_PageDataType> snapshot) {
    setState(() {
      _snapshot = snapshot;
    });
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
}
