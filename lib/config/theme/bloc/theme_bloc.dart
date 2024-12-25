import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../solara_theme.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(themeDataLight) {
    on<InitialThemeSetEvent>(_onInitialThemeSetEvent);
    on<ThemeSwitchEvent>(_onThemeSwitchEvent);
  }

  void _onThemeSwitchEvent(ThemeSwitchEvent event, Emitter<ThemeData> emit) {
    final isDark = state == themeDataDark;
    emit(isDark ? themeDataLight : themeDataDark);
    setTheme(isDark);
  }

  Future<void> _onInitialThemeSetEvent(
      InitialThemeSetEvent event, Emitter<ThemeData> emit) async {
    final bool hasDarkTheme = await isDark();
    if (hasDarkTheme) {
      emit(themeDataDark);
    } else {
      emit(themeDataLight);
    }
  }
}
