import 'package:emobook/models/emotion.dart';
import 'package:emobook/widgets/emotion_select_item.dart';
import 'package:flutter/material.dart';
import 'package:emobook/extensions/string.dart';

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
            title: Text('Select Emotions'),
          ),
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: _allEmotions
          .map((e) => EmotionSelectItem(
              title: e.localized(context).toUpperCaseFirst(),
              isSelected: selectedEmotions.contains(e),
        onTap: () => _triggerEmotion(e),
      ))
          .toList(growable: false),
    );
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

const _allEmotions = <Emotion>[
  Emotion.grateful,
];
