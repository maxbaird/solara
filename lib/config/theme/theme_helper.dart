part of 'solara_theme.dart';

Future<bool> isDark() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('is_dark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('is_dark', !isDark);
}

/// Returns either the [whenLight] or [whenDark] color based on the current theme.
/// [whenLight] is the color to use when the light theme is active. [whenDark] is the
/// color to use when the dark theme is active.
Color themeColor(
  BuildContext context, {
  required Color whenLight,
  required Color whenDark,
}) {
  return Theme.of(context).brightness == Brightness.light
      ? whenLight
      : whenDark;
}
