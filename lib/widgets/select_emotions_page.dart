import 'package:emobook/models/emotion.dart';
import 'package:emobook/widgets/emotion_select_item.dart';
import 'package:emobook/widgets/searchable_async_view.dart';
import 'package:flutter/material.dart';
import 'package:emobook/extensions/string.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectEmotionsPage extends StatefulWidget {
  static const routeName = '/emotions/select';

  const SelectEmotionsPage({Key? key, required this.selectedEmotions})
      : super(key: key);

  final List<Emotion> selectedEmotions;

  @override
  State<SelectEmotionsPage> createState() => _SelectEmotionsPageState();
}

class _SelectEmotionsPageState extends State<SelectEmotionsPage> {
  var selectedEmotions = <Emotion>{};

  @override
  void initState() {
    super.initState();
    selectedEmotions = widget.selectedEmotions.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, selectedEmotions.toList(growable: false));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.selectEmotionsPage_title),
          ),
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SearchableAsyncView<List<Emotion>>(
      dataGetter: (useCache) async => _allEmotions,
      dataFilter: (data, string) => _filterData(context, data, string),
      builder: (context, data) => ListView(
        children: data
            .map((e) => EmotionSelectItem(
                  title: e.localized(context).toUpperCaseFirst(),
                  isSelected: selectedEmotions.contains(e),
                  onTap: () => _triggerEmotion(e),
                ))
            .toList(growable: false),
      ),
    );
  }

  Future<List<Emotion>> _filterData(BuildContext context,
      List<Emotion> dataFilter, String searchString) async {
    final allLocalized = dataFilter.map((e) => e.localized(context));
    final result = dataFilter
        .where((e) => e
            .localized(context)
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList(growable: false);
    return result;
  }

  void _triggerEmotion(Emotion emotion) {
    setState(() {
      if (selectedEmotions.contains(emotion)) {
        selectedEmotions.remove(emotion);
      } else {
        selectedEmotions.add(emotion);
      }
    });
  }
}

const _allEmotions = Emotion.values;
