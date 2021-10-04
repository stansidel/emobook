import 'package:emobook/models/emo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'loading_screen.dart';

class SnapshotBasedScreen<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(BuildContext context, T value) buildChild;
  final Widget? loadingScreen;
  final VoidCallback? onTryAgain;

  const SnapshotBasedScreen({
    Key? key,
    required this.snapshot,
    required this.buildChild,
    this.onTryAgain,
    this.loadingScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingScreen ?? const LoadingScreen(text: 'Loading...');
    }
    if (snapshot.hasError) {
      return _buildError(context, reason: snapshot.error?.toString());
    }
    final data = snapshot.data;
    if (data == null) {
      return _buildError(context, reason: 'No data');
    }
    return buildChild(context, data);
  }

  Widget _buildError(BuildContext context, {String? reason}) {
    final textColor = EmoTheme.of(context).onErrorColor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: EmoTheme.of(context).errorColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.snapshotBasedScreen_errorScreen_title,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: textColor),
          ),
          if (reason != null)
            Text(
              reason,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: textColor),
            ),
          ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!
                    .snapshotBasedScreen_errorScreen_tryAgainButton_title,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: textColor),
              ),
              onPressed: () {
                onTryAgain?.call();
              }),
        ],
      ),
    );
  }
}
