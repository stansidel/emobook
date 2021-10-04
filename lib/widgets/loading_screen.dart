import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String? text;

  const LoadingScreen({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (text != null) const SizedBox(height: 16.0),
          if (text != null) Text(text!),
        ],
      ),
    );
  }
}
