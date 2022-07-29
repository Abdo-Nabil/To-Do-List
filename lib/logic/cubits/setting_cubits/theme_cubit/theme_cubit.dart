import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/my_themes.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitialState());

//-------------------* const *---------------------------
  static String systemDefault = MyThemes.themeModeList[0];
  static String lightTheme = MyThemes.themeModeList[1];
  static String darkTheme = MyThemes.themeModeList[2];
//--------------------------------------------------------

  ThemeMode? _themeMode;
  ThemeMode? get themeMode => _themeMode;

  Future<void> getThemeMode() async {
    // emit(ThemeLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prefsThemeMode = prefs.getString('themeMode');
    //null check performed in the app main function, so it will not be null !

    late String stringThemeMode;

    if (prefsThemeMode == systemDefault) {
      stringThemeMode = systemDefault;
    } else if (prefsThemeMode == lightTheme) {
      stringThemeMode = lightTheme;
    } else {
      stringThemeMode = darkTheme;
    }

    emit(GetThemeState(stringThemeMode));
  }

  Future<void> selectThemeMode(String selectedTheme) async {
    // emit(ThemeLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', selectedTheme);

    late String stringThemeMode;

    if (selectedTheme == systemDefault) {
      _themeMode = ThemeMode.system;
      stringThemeMode = systemDefault;
    } else if (selectedTheme == lightTheme) {
      _themeMode = ThemeMode.light;
      stringThemeMode = lightTheme;
    } else {
      _themeMode = ThemeMode.dark;
      stringThemeMode = darkTheme;
    }
    emit(GetThemeState(stringThemeMode));
  }
}
