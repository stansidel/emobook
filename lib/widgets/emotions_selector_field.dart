import 'package:emobook/extensions/string.dart';
import 'package:emobook/models/emotion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmotionsSelectorField extends StatelessWidget {
  final List<Emotion> emotions;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const EmotionsSelectorField({
    Key? key,
    required this.emotions,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderRadius = 5.0,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.0),
    this.textStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Padding(
          padding: contentPadding,
          child: Text(
            _getText(context, emotions),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

String _getText(BuildContext context, List<Emotion>? emotions) {
  if (emotions == null || emotions.isEmpty) {
    return AppLocalizations.of(context)!.emotionsSelectorField_nothingSelected;
  }
  final text = emotions.map((e) => e.localized(context)).join(', ');
  return text.toUpperCaseFirst();
}
