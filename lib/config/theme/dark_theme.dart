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
  onSurface: kSolaraWhiteGreenish,
);

final ThemeData themeDataDark = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  colorScheme: _colorSchemeDark,
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: kSolaraDarkGreen,
    titleTextStyle: TextStyle(color: kSolaraWhite),
  ),
  tabBarTheme: TabBarTheme().copyWith(
    indicatorColor: kSolaraGreenDark2,
    dividerColor: kSolaraGreyLight,
    labelColor: kSolaraGreenDark2,
    unselectedLabelColor: kSolaraGreyLight,
  ),
  scaffoldBackgroundColor: kSolaraDarkGreen,
  switchTheme: SwitchThemeData().copyWith(
    trackColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return kSolaraGreenDark;
        } else {
          return kSolaraGreyGreen;
        }
      },
    ),
    thumbColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return kSolaraWhite;
        } else {
          return kSolaraGreenDark;
        }
      },
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: kSolaraGreenDark,
      iconColor: kSolaraGreenDark,
      backgroundColor: kSolaraGreyGreen,
    ),
  ),
);
