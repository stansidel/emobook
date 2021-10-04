import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:emobook/widgets/entries_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmoApp extends StatelessWidget {
  const EmoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = EmoTheme.defaultTheme;
    return theme.widget(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: theme.colorScheme,
        ),
        home: EntriesListPage(
          repository: DayEntriesRepository(),
        ),
      ),
    );
  }
}
