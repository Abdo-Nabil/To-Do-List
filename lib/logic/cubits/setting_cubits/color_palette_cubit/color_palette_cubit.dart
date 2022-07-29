import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/my_themes.dart';

part 'color_palette_state.dart';

class ColorPaletteCubit extends Cubit<ColorPaletteState> {
  ColorPaletteCubit() : super(ColorPaletteInitialState());

  //ToDo: the problem is that primarySwatch only accepts MaterialColor class not Color class like primaryColor
  // MaterialColor defaultColor = Colors.blue;
  MaterialColor? _primarySwatch;
  MaterialColor? get primarySwatch => _primarySwatch;

  Future<void> getColor() async {
    // emit(ColorPaletteLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedColor = prefs.getInt('intColor');
    //null check performed in the app main function, so it will not be null !
    List selectedColorProperty = MyThemes.colorsMap[storedColor]!;
    final int intColor = selectedColorProperty[0];
    final String stringColor = selectedColorProperty[2];

    emit(GetColorPaletteState(stringColor, intColor));
  }

  Future<void> selectColor(int colorValue) async {
    // emit(ColorPaletteLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List selectedColorProperty = MyThemes.colorsMap[colorValue]!;
    final int intColor = selectedColorProperty[0];
    final MaterialColor color = selectedColorProperty[1];
    final String stringColor = selectedColorProperty[2];

    _primarySwatch = color;
    await prefs.setInt('intColor', intColor);

    emit(GetColorPaletteState(stringColor, intColor));
  }
}
