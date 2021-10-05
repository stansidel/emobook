import 'package:emobook/models/emo_theme.dart';
import 'package:emobook/repositories/day_entries_repository.dart';
import 'package:emobook/widgets/day_entry_edit_page.dart';
import 'package:emobook/widgets/entries_list_page.dart';
import 'package:emobook/widgets/select_emotions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmoApp extends StatefulWidget {
  const EmoApp({Key? key}) : super(key: key);

  @override
  State<EmoApp> createState() => _EmoAppState();
}

class _EmoAppState extends State<EmoApp> {
  final _dayEntriesRepository = DayEntriesRepository();

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
        onGenerateRoute: (RouteSettings settings) {
          final routes = <String, WidgetBuilder>{
            '/': (context) => EntriesListPage(
                  repository: _dayEntriesRepository,
                ),
            DayEntryEditPage.routeName: (context) => DayEntryEditPage(
                repository: _dayEntriesRepository, options: _getArg(settings)),
            SelectEmotionsPage.routeName: (context) =>
                SelectEmotionsPage(selectedEmotions: _getArg(settings)),
          };
          WidgetBuilder builder = routes[settings.name]!;
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}

T? _getArg<T>(RouteSettings settings) {
  final arg = settings.arguments;
  assert(arg is T || arg == null,
      'Wrong argument type for the route. Expected $T, got ${arg.runtimeType}.');
  if (arg is T) {
    return arg;
  }
  if (arg == null) {
    return null;
  }
  return null;
}
