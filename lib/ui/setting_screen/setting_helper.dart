import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/font_size_cubit/font_size_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/theme_cubit/theme_cubit.dart';
import 'package:to_do_list/services/my_themes.dart';
import 'package:to_do_list/services/constants.dart';

class SettingHelper {
  //
  //check if the old category was a startup category
  static Future<void> editSelectedStartupCategory({
    required bool isDeleted,
    required CategoryModel oldCategoryModel,
    required CategoryModel newCategoryModel,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final startupCategory = prefs.getString('startupCategory');
    //
    if (startupCategory == oldCategoryModel.categoryName) {
      if (isDeleted) {
        await prefs.setString(
            'startupCategory', CategoryModel.allCategories.categoryName);
      } else {
        await prefs.setString('startupCategory', newCategoryModel.categoryName);
      }
    }
  }

  //
  static Future<String> getStartupCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedStartupCategory = prefs.getString('startupCategory');
    late String startupCategory;

    if (storedStartupCategory == null) {
      startupCategory = CategoryModel.allCategories.categoryName;
    } else {
      startupCategory = storedStartupCategory;
    }

    return startupCategory;
  }

  //
  static Future<double> getFontSizeFactor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? fontSizeFactor = prefs.getDouble('fontSizeFactor');

    if (fontSizeFactor == null) {
      await prefs.setDouble('fontSizeFactor', FontSizeCubit.normalFactor);
      return FontSizeCubit.normalFactor;
    } else {
      if (fontSizeFactor == FontSizeCubit.normalFactor) {
        await prefs.setDouble('fontSizeFactor', FontSizeCubit.normalFactor);
        return FontSizeCubit.normalFactor;
      } else if (fontSizeFactor == FontSizeCubit.largeFactor) {
        await prefs.setDouble('fontSizeFactor', FontSizeCubit.largeFactor);
        return FontSizeCubit.largeFactor;
      } else {
        await prefs.setDouble('fontSizeFactor', FontSizeCubit.smallFactor);
        return FontSizeCubit.smallFactor;
      }
    }
  }

  //
  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prefsThemeMode = prefs.getString('themeMode');

    if (prefsThemeMode == null) {
      await prefs.setString('themeMode', ThemeCubit.systemDefault);
      return ThemeMode.system;
    } else {
      if (prefsThemeMode == ThemeCubit.systemDefault) {
        await prefs.setString('themeMode', ThemeCubit.systemDefault);
        return ThemeMode.system;
      } else if (prefsThemeMode == ThemeCubit.lightTheme) {
        await prefs.setString('themeMode', ThemeCubit.lightTheme);
        return ThemeMode.light;
      } else {
        await prefs.setString('themeMode', ThemeCubit.darkTheme);
        return ThemeMode.dark;
      }
    }
  }

  //
  static Future<MaterialColor> getColor() async {
    const MaterialColor defaultColor = appDefaultColor;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedColor = prefs.getInt('intColor');

    if (storedColor == null) {
      await prefs.setInt('intColor', defaultColor.value);
      return defaultColor;
    } else {
      await prefs.setInt('intColor', storedColor);
      return MyThemes.colorsMap[storedColor]![1];
    }
  }
  //
}
