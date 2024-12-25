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
  onSurface: kSolaraGreenDark,
);

final ThemeData themeDataLight = ThemeData.light(
  useMaterial3: true,
).copyWith(
  colorScheme: _colorSchemeLight,
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: kSolaraWhiteGreenish,
    titleTextStyle: TextStyle(color: kSolaraDarkGreen),
  ),
  tabBarTheme: TabBarTheme().copyWith(
    indicatorColor: kSolaraGreenDark,
    dividerColor: kSolaraGreyLight,
    labelColor: kSolaraGreenDark,
    unselectedLabelColor: kSolaraGreyDark,
  ),
  scaffoldBackgroundColor: kSolaraWhiteGreenish,
  switchTheme: SwitchThemeData().copyWith(
    trackColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return kSolaraGreenDark;
        } else {
          return kSolaraWhite;
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
    style: ElevatedButton.styleFrom(foregroundColor: kSolaraGreenDark),
  ),
);
