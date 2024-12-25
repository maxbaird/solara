part of 'solara_theme.dart';

const ColorScheme _colorSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: kSolaraDarkGreen,
  onPrimary: kSolaraWhite,
  secondary: kSolaraGreyBright,
  onSecondary: kSolaraGreyBright,
  error: kSolaraRed,
  onError: kSolaraWhite,
  surface: kSolaraOlive3,
  onSurface: kSolaraWhiteBluish,
);

final ThemeData themeDataDark = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  colorScheme: _colorSchemeDark,
);
