import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'emo_theme.freezed.dart';

class _EmoThemeWidget extends InheritedWidget {
  const _EmoThemeWidget({Key? key, required Widget child, required this.theme})
      : super(key: key, child: child);

  final EmoTheme theme;

  @override
  bool updateShouldNotify(covariant _EmoThemeWidget oldWidget) {
    return theme != oldWidget.theme;
  }
}

@freezed
class EmoTheme with _$EmoTheme {
  const factory EmoTheme({
    required Color listHeaderBgColor,
    required Color dismissDeleteBgColor,
    required Color dismissDeleteFgColor,
    required Color primaryColor,
    required Color primaryVariantColor,
    required Color secondaryColor,
    required Color secondaryVariantColor,
    required Color surfaceColor,
    required Color backgroundColor,
    required Color errorColor,
    required Color onPrimaryColor,
    required Color onSecondaryColor,
    required Color onSurfaceColor,
    required Color onBackgroundColor,
    required Color onErrorColor,
    required Brightness brightness,
  }) = _EmoTheme;

  factory EmoTheme.fromPrimaryColor({
    required Color primaryColor,
    required Color listHeaderBgColor,
    Color? dismissDeleteBgColor,
    Color? dismissDeleteFgColor,
  }) {
    final scheme =
        ColorScheme.fromSwatch(primarySwatch: primaryColor.materialColor);
    return EmoTheme(
      listHeaderBgColor: listHeaderBgColor,
      dismissDeleteBgColor: dismissDeleteBgColor ?? scheme.error,
      dismissDeleteFgColor: dismissDeleteFgColor ?? scheme.onError,
      primaryColor: primaryColor,
      primaryVariantColor: scheme.primaryVariant,
      secondaryColor: scheme.secondary,
      secondaryVariantColor: scheme.secondaryVariant,
      surfaceColor: scheme.surface,
      backgroundColor: scheme.background,
      errorColor: scheme.error,
      onPrimaryColor: scheme.onPrimary,
      onSecondaryColor: scheme.onSecondary,
      onSurfaceColor: scheme.onSurface,
      onBackgroundColor: scheme.onBackground,
      onErrorColor: scheme.onError,
      brightness: scheme.brightness,
    );
  }

  const EmoTheme._();

  static EmoTheme get defaultTheme => EmoTheme.fromPrimaryColor(
      primaryColor: Colors.lightBlue,
      listHeaderBgColor: const Color(0xFFEDECEC));

  Widget widget({required Widget child}) {
    return _EmoThemeWidget(child: child, theme: this);
  }

  static EmoTheme of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_EmoThemeWidget>();
    return widget?.theme ?? defaultTheme;
  }

  ColorScheme get colorScheme {
    return ColorScheme(
      primary: primaryColor,
      primaryVariant: primaryVariantColor,
      secondary: secondaryColor,
      secondaryVariant: secondaryVariantColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onSurface: onSurfaceColor,
      onBackground: onBackgroundColor,
      onError: onErrorColor,
      brightness: brightness,
    );
  }
}

extension _GetMaterialColor on Color {
  MaterialColor get materialColor {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
}
