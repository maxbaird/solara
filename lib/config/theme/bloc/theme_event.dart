part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {
  const ThemeEvent();
}

class InitialThemeSetEvent extends ThemeEvent {
  const InitialThemeSetEvent();
}

class ThemeSwitchEvent extends ThemeEvent {
  const ThemeSwitchEvent();
}
