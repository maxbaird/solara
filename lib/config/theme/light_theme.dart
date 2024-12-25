part of 'solara_theme.dart';

const ColorScheme _colorSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: kSolaraDarkGreen,
    onPrimary: kSolaraDarkGreen,
    secondary: kSolaraGreyDark,
    onSecondary: kSolaraGreenDark,
    error: kSolaraRed,
    onError: kSolaraWhite,
    surface: kSolaraWhite,
    onSurface: kSolaraGreenDark);

final ThemeData themeDataLight = ThemeData.light(
  useMaterial3: true,
).copyWith(
  colorScheme: _colorSchemeLight,
);
