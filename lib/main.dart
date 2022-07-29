import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/theme_cubit/theme_cubit.dart';
import 'package:to_do_list/services/notification_helper.dart';
import 'package:to_do_list/the_material_app.dart';
import 'package:to_do_list/ui/setting_screen/setting_helper.dart';
import 'logic/bloc_observer.dart';
import 'logic/cubits/screens_cubits/categories_manager_cubit/categories_manager_cubit.dart';
import 'logic/cubits/screens_cubits/completed_tasks_cubit/completed_tasks_cubit.dart';
import 'logic/cubits/screens_cubits/edit_task_cubit/edit_task_cubit.dart';
import 'logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'logic/cubits/screens_cubits/new_task_cubit/new_task_cubit.dart';
import 'logic/cubits/setting_cubits/color_palette_cubit/color_palette_cubit.dart';
import 'logic/cubits/setting_cubits/font_size_cubit/font_size_cubit.dart';
import 'logic/cubits/setting_cubits/startup_category_cubit/startup_category_cubit.dart';
import 'logic/cubits/setting_cubits/time_format_cubit/time_format_cubit.dart';
import 'logic/cubits/setting_cubits/week_first_day_cubit/week_starting_day_cubit.dart';

Future<String> getInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? initialRoute = prefs.getString('storedRoute');
  if (initialRoute == null) {
    return 'TutorialScreen';
  }
  return 'HomeScreen';
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //disable landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //
  await NotificationHelper.initializeNotification();
  final String initialRoute = await getInitialRoute();
  //
  final appVersion = await getAppVersion();
  //the (font size factor, theme mode, picked color)must be initialized here ==>
  final double fontSizeFactor = await SettingHelper.getFontSizeFactor();
  final ThemeMode themeMode = await SettingHelper.getThemeMode();
  final MaterialColor color = await SettingHelper.getColor();
  //
  Bloc.observer = MyBlocObserver();
  //
  runApp(
    MyApp(
      initialRoute: initialRoute,
      appVersion: appVersion,
      fontSizeFactor: fontSizeFactor,
      themeMode: themeMode,
      color: color,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final String appVersion;
  final double fontSizeFactor;
  final ThemeMode themeMode;
  final MaterialColor color;

  const MyApp({
    required this.initialRoute,
    required this.appVersion,
    required this.fontSizeFactor,
    required this.themeMode,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (BuildContext context) => CategoryCubit(),
        ),
        BlocProvider<SearchCubit>(
          create: (BuildContext context) => SearchCubit(),
        ),
        BlocProvider<SelectionCubit>(
          create: (BuildContext context) => SelectionCubit(),
        ),
        BlocProvider<DateAndTimeCubit>(
          create: (BuildContext context) => DateAndTimeCubit(),
        ),
        BlocProvider<HomeScreenCubit>(
          create: (BuildContext context) => HomeScreenCubit(),
        ),
        BlocProvider<NewTaskCubit>(
          create: (BuildContext context) => NewTaskCubit(),
        ),
        BlocProvider<EditTaskCubit>(
          create: (BuildContext context) => EditTaskCubit(),
        ),
        BlocProvider<CategoriesManagerCubit>(
          create: (BuildContext context) => CategoriesManagerCubit(),
        ),
        BlocProvider<CompletedTasksCubit>(
          create: (BuildContext context) => CompletedTasksCubit(),
        ),

//----------------------------* setting cubits *-----------------

        BlocProvider<StartupCategoryCubit>(
          create: (BuildContext context) => StartupCategoryCubit(),
        ),
        BlocProvider<TimeFormatCubit>(
          create: (BuildContext context) => TimeFormatCubit(),
        ),
        BlocProvider<TimeFormatCubit>(
          create: (BuildContext context) => TimeFormatCubit(),
        ),
        BlocProvider<WeekStartingDayCubit>(
          create: (BuildContext context) => WeekStartingDayCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<FontSizeCubit>(
          create: (BuildContext context) => FontSizeCubit(),
        ),
        BlocProvider<ColorPaletteCubit>(
          create: (BuildContext context) => ColorPaletteCubit(),
        ),
      ],
      child: TheMaterialApp(
        initialRoute: initialRoute,
        appVersion: appVersion,
        fontSizeFactor: fontSizeFactor,
        themeMode: themeMode,
        color: color,
      ),
    );
  }
}
