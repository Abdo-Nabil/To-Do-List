import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/theme_cubit/theme_cubit.dart';
import 'package:to_do_list/ui/about_screen/about_screen.dart';
import 'package:to_do_list/ui/categories_manager_screen/categories_manager_screen.dart';
import 'package:to_do_list/ui/completed_tasks_screen/completed_tasks_screen.dart';
import 'package:to_do_list/ui/edit_task_screen/edit_task_screen.dart';
import 'package:to_do_list/ui/home_screen/home_screen.dart';
import 'package:to_do_list/ui/new_task_screen/new_task_screen.dart';
import 'package:to_do_list/ui/search_screen/search_screen.dart';
import 'package:to_do_list/ui/setting_screen/setting_screen.dart';
import 'package:to_do_list/ui/tutorial_screen/tutorial_screen.dart';
import 'package:to_do_list/services/my_themes.dart';

class TheMaterialApp extends StatelessWidget {
  final String initialRoute;
  final String appVersion;
  final double fontSizeFactor;
  final ThemeMode themeMode;
  final MaterialColor color;

  const TheMaterialApp({
    required this.initialRoute,
    required this.appVersion,
    required this.fontSizeFactor,
    required this.themeMode,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final selectedThemeMode =
        BlocProvider.of<ThemeCubit>(context, listen: true).themeMode;
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // Add the builder here
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      themeMode: selectedThemeMode ?? themeMode,
      theme: MyThemes.getLightTheme(
        context: context,
        fontSizeFactor: fontSizeFactor,
        color: color,
      ),
      darkTheme: MyThemes.getDarkTheme(
        context: context,
        fontSizeFactor: fontSizeFactor,
        color: color,
      ),
      initialRoute: initialRoute,
      //ToDo 1: implement safe area
      routes: {
        'HomeScreen': (context) => HomeScreen(),
        'NewTaskScreen': (context) => NewTaskScreen(),
        'EditTaskScreen': (context) => EditTaskScreen(),
        'CompletedTasksScreen': (context) => CompletedTasksScreen(),
        'CategoriesManagerScreen': (context) => CategoriesManagerScreen(),
        'SettingScreen': (context) => SettingScreen(),
        'TutorialScreen': (context) => TutorialScreen(),
        'AboutScreen': (context) => AboutScreen(appVersion: appVersion),
        'SearchScreen': (context) => SearchScreen(),
      },
    );
  }
}
