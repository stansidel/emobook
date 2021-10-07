import 'package:emobook/widgets/emo_list_search_field.dart';
import 'package:emobook/widgets/snapshot_based_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef SearchableListDataGetter<ResultType> = Future<ResultType> Function(
    bool useCache);
typedef SearchableListDataFilter<ResultType> = Future<ResultType> Function(
    ResultType fullData, String searchString);
typedef SearchableListBuilder<ResultType> = Widget Function(
    BuildContext context, ResultType filteredData);

class SearchableAsyncView<ResultsType> extends StatefulWidget {
  /// View with a search field a the top. This widget handles interactions
  /// with the search field and manages states of the returned data.
  ///
  /// [dataGetter] is expected to throw exceptions. This widget handles such
  /// exceptions and displays an error screen in place of the root widget.
  /// This screen includes the retry button. This screens come from
  /// [SnapshotBasedScreen], which is used internally.
  ///
  /// [dataFilter] is guaranteed to always get non-empty [searchString].
  ///
  /// Provide [hasData] checker to use [noDataScreen] or [noSearchResultsScreen].
  ///
  /// When [hasData] and [noDataScreen] provided, [noDataScreen] widget
  /// is displayed as the root widget without the search field if [dataGetter]
  /// returns an empty result.
  ///
  /// When [hasData] and [noSearchResultsScreen] provided,
  /// [noSearchResultsScreen] widget is displayed below the search field in
  /// place of the [builder] output if [dataGetter] returns non-empty result
  /// but [dataFilter] returns an empty result.
  const SearchableAsyncView(
      {Key? key,
      required this.dataGetter,
      required this.dataFilter,
      required this.builder,
      this.loadingScreen,
      this.noDataScreen,
      this.noSearchResultsScreen,
      this.hasData})
      : super(key: key);

  final SearchableListDataGetter<ResultsType> dataGetter;
  final SearchableListDataFilter<ResultsType> dataFilter;
  final SearchableListBuilder<ResultsType> builder;
  final Widget? loadingScreen;
  final Widget? noDataScreen;
  final Widget? noSearchResultsScreen;
  final bool Function(ResultsType)? hasData;

  @override
  _SearchableAsyncViewState<ResultsType> createState() =>
      _SearchableAsyncViewState<ResultsType>();
}

class _SearchableAsyncViewState<ResultsType>
    extends State<SearchableAsyncView<ResultsType>> {
  AsyncSnapshot<ResultsType> _snapshot = const AsyncSnapshot.waiting();
  final _searchController = TextEditingController();
  ResultsType? _cache;

  @override
  void initState() {
    super.initState();
    _updateData(null, useCache: true);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _updateData(context, useCache: false),
      child: SnapshotBasedScreen(
        snapshot: _snapshot,
        onTryAgain: () => _updateData(context),
        loadingScreen: widget.loadingScreen,
        buildChild: (context, ResultsType data) {
          if (widget.hasData?.call(data) == false &&
              _searchText.isEmpty &&
              widget.noDataScreen != null) {
            return widget.noDataScreen!;
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 9.0, left: 16.0, right: 16.0, bottom: 2.0),
                child: EmoListSearchField(
                  controller: _searchController,
                ),
              ),
              Expanded(
                child: _buildBody(context, data),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ResultsType data) {
    if (widget.hasData?.call(data) == false &&
        widget.noSearchResultsScreen != null) {
      return widget.noSearchResultsScreen!;
    }
    return widget.builder(context, data);
  }

  Future<void> _updateData(BuildContext? context,
      {bool useCache = true}) async {
    final cached = _cache;
    if (useCache && cached != null) {
      _setData(cached);
    }
    if (!_snapshot.hasData) {
      _setSnapshot(const AsyncSnapshot.waiting());
    }
    try {
      final data = await widget.dataGetter(useCache);
      _cache = data;
      _setData(data);
    } catch (e) {
      if (!_snapshot.hasData) {
        _setSnapshot(AsyncSnapshot.withError(ConnectionState.done, e));
      } else if (context != null) {
        final snackBar = SnackBar(
            content:
                Text(AppLocalizations.of(context)!.general_error_unexpected));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> _setData(ResultsType data) async {
    if (_searchText.isEmpty) {
      _setSnapshot(AsyncSnapshot.withData(ConnectionState.done, data));
      return;
    }
    final filteredData = await widget.dataFilter(data, _searchText);
    _setSnapshot(AsyncSnapshot.withData(ConnectionState.done, filteredData));
  }

  String get _searchText => _searchController.text;

  void _onSearchChanged() {
    _updateData(null, useCache: true);
  }

  void _setSnapshot(AsyncSnapshot<ResultsType> newSnapshot) {
    if (!mounted) {
      return;
    }
    setState(() {
      _snapshot = newSnapshot;
    });
  }
}
