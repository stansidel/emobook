import 'package:emobook/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmoCheckbox extends StatelessWidget {
  const EmoCheckbox(
      {Key? key,
        this.width = 44.0,
        required this.isChecked,
        this.color = const Color(0xFF888888)})
      : super(key: key);

  final double width;
  final bool isChecked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: isChecked ? _buildChecker() : null,
    );
  }

  Widget _buildChecker() {
    return Center(
      child: SvgPicture.asset(
        Assets.svg.emoSimpleCheckmark,
        color: color,
      ),
    );
  }
}
