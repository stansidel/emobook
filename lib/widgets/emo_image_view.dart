import 'dart:io';

import 'package:emobook/models/emo_file.dart';
import 'package:flutter/material.dart';

class EmoImageView extends StatelessWidget {
  const EmoImageView({Key? key, required this.image}) : super(key: key);

  final EmoFile image;

  @override
  Widget build(BuildContext context) {
    switch (image.storage) {
      case EmoFileStorage.localFile:
        return Image.file(File(image.path));
    }
  }
}
