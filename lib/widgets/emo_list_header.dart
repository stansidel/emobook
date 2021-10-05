import 'package:emobook/models/emo_theme.dart';
import 'package:flutter/material.dart';

class EmoListHeader extends StatelessWidget {
  const EmoListHeader(
      {Key? key, required this.title, this.backgroundColor = Colors.grey})
      : super(key: key);

  final String title;
  final Color backgroundColor;

  static EmoListHeader themeDefault(
      {Key? key, required EmoTheme theme, required String title}) {
    return EmoListHeader(
      key: key,
      title: title,
      backgroundColor: theme.listHeaderBgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        child: Text(title),
        decoration: BoxDecoration(color: backgroundColor),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      ),
    );
  }
}
