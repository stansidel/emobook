import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/widgets/emo_checkbox.dart';
import 'package:flutter/material.dart';

class EmotionSelectItem extends StatelessWidget {
  const EmotionSelectItem({
    Key? key,
    required this.title,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          children: [
            const SizedBox(width: 20.0),
            EmoCheckbox(
              isChecked: isSelected,
              width: 24.0,
              color: EmoTheme.of(context).secondaryColor,
            ),
            const SizedBox(width: 6.0),
            Expanded(child: Text(title)),
          ],
        ),
      ),
    );
  }
}
