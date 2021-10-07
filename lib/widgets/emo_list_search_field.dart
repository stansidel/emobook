import 'dart:math' as math;
import 'package:emobook/models/emo_theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmoListSearchField extends StatefulWidget {
  const EmoListSearchField({
    Key? key,
    this.onChanged,
    this.controller,
    this.borderColor = const Color(0x1E767680),
    this.textColor = const Color(0x4C3C3C43),
    this.iconSize = 16.0,
    this.iconPadding = 6.0,
    this.borderRadius = 10.0,
    this.verticalPadding = 8.0,
    this.horizontalPadding = 8.0,
  }) : super(key: key);

  factory EmoListSearchField.fromColors(
      {Key? key,
      ValueChanged<String>? onChanged,
      TextEditingController? controller,
      required EmoTheme theme}) {
    return EmoListSearchField(
      key: key,
      onChanged: onChanged,
      controller: controller,
      borderColor: theme.searchFieldColor,
      textColor: theme.searchFieldTextColor,
    );
  }

  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;

  final Color borderColor;
  final Color textColor;

  final double iconSize;
  final double iconPadding;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  _EmoListSearchFieldState createState() =>
      _EmoListSearchFieldState();
}

class _EmoListSearchFieldState extends State<EmoListSearchField> {
  TextEditingController get _controller =>
      widget.controller ?? _innerController;

  final _innerController = TextEditingController();

  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _innerController.dispose();
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(color: widget.textColor),
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.emoListSearchField_hint,
              prefixIcon: Icon(Icons.search, size: widget.iconSize),
              prefixIconConstraints: BoxConstraints(
                minWidth: widget.iconSize + widget.iconPadding * 2,
                minHeight: widget.iconSize + widget.iconPadding * 2,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              fillColor: widget.borderColor,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.only(
                left:
                    math.max(0, widget.horizontalPadding - widget.iconPadding),
                top: widget.verticalPadding,
                right: widget.horizontalPadding,
                bottom: widget.verticalPadding,
              ),
            ),
          ),
        ),
        if (_controller.text.isNotEmpty)
          TextButton(
            onPressed: _resetSearch,
            child: Text(AppLocalizations.of(context)!
                .emoListSearchField_cancelButton_title),
          ),
      ],
    );
  }

  String _previousValue = '';

  void _onTextChanged() {
    if (_previousValue == _controller.text) {
      return;
    }
    widget.onChanged?.call(_controller.text);
    _previousValue = _controller.text;
  }

  void _resetSearch() {
    _controller.clear();
    _focusNode.unfocus();
  }
}
