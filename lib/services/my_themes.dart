import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/color_palette_cubit/color_palette_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/font_size_cubit/font_size_cubit.dart';

class MyThemes {
  static const List<String> themeModeList = const [
    'System default',
    'Light mode',
    'Dark mode',
  ];

  static const List<Color> colorsList = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    //Colors.black,
  ];

  static const Map<int, List> colorsMap = const {
    4294198070: [4294198070, Colors.red, 'Red'],
    4293467747: [4293467747, Colors.pink, 'Pink'],
    4288423856: [4288423856, Colors.purple, 'Purple'],
    4284955319: [4284955319, Colors.deepPurple, 'Deep purple'],
    4282339765: [4282339765, Colors.indigo, 'Indigo'],
    4280391411: [4280391411, Colors.blue, 'Blue'],
    4278430196: [4278430196, Colors.lightBlue, 'Light blue'],
    4278238420: [4278238420, Colors.cyan, 'Cyan'],
    4278228616: [4278228616, Colors.teal, 'Teal'],
    4283215696: [4283215696, Colors.green, 'Green'],
    4287349578: [4287349578, Colors.lightGreen, 'Light Green'],
    4291681337: [4291681337, Colors.lime, 'Lime'],
    4294961979: [4294961979, Colors.yellow, 'Yellow'],
    4294951175: [4294951175, Colors.amber, 'Amber'],
    4294940672: [4294940672, Colors.orange, 'Orange'],
    4294924066: [4294924066, Colors.deepOrange, 'Deep orange'],
    4286141768: [4286141768, Colors.brown, 'Brown'],
    4288585374: [4288585374, Colors.grey, 'Grey'],
    4284513675: [4284513675, Colors.blueGrey, 'Blue Grey'],
    //4278190080: [4278190080, Colors.black, 'Black'],
  };
  //
  static ThemeData getLightTheme({
    required BuildContext context,
    required double fontSizeFactor,
    required MaterialColor color,
  }) {
    //note: that app font size changes automatically with the system setting only if u use Theme.of(context).textTheme.

    final MaterialColor primarySwatch =
        BlocProvider.of<ColorPaletteCubit>(context, listen: true)
                .primarySwatch ??
            color;

    final double fontFactor =
        BlocProvider.of<FontSizeCubit>(context, listen: true).fontSizeFactor ??
            fontSizeFactor;

    final ThemeData themeData = ThemeData(
      primarySwatch: primarySwatch,
      scrollbarTheme: ScrollbarThemeData(
        radius: Radius.circular(10),
        // thickness: MaterialStateProperty.all(20),
        //isAlwaysShown: true, // it cause a problem 'exception' ,tackle it later
        //thickness: MaterialStateProperty.all(8),  //default is 8
        thumbColor: MaterialStateProperty.all(
          primarySwatch.shade300,
        ),
      ),
      iconTheme: IconThemeData(
        color: primarySwatch,
        // size: 24 * fontFactor,
      ),
      cardTheme: CardTheme(
        color: Colors.white54,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primarySwatch.shade200,
        selectionHandleColor: primarySwatch.shade300,
      ),
      appBarTheme: AppBarTheme(
        //ToDo : Note, without next line theme will not provided !!!
        backwardsCompatibility: false,
        textTheme: Theme.of(context).textTheme,
        //ToDo : for white icons in status bar use ==>
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // colorScheme: ColorScheme.fromSwatch(
      //   primarySwatch: primarySwatch ,
      // ),

      //ToDo: note the trick and the bug with color scheme :(
      textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: fontFactor,
            fontSizeDelta: 0,
          ),
      //
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
    //
    return themeData;
  }

  static ThemeData getDarkTheme({
    required BuildContext context,
    required double fontSizeFactor,
    required MaterialColor color,
  }) {
    //note: that app font size changes automatically with the system setting

    final MaterialColor primarySwatch = Colors.teal;

    final double fontFactor =
        BlocProvider.of<FontSizeCubit>(context, listen: true).fontSizeFactor ??
            fontSizeFactor;

    final ThemeData themeData = ThemeData(
      primarySwatch: primarySwatch,
      primaryColorLight: Colors.grey[700],
      //accentColor: Colors.tealAccent,

      iconTheme: IconThemeData(
        //color: primarySwatch,
        color: Colors.white70,
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      appBarTheme: AppBarTheme(
        //ToDo : Note, without next line theme will not provided !!!
        backwardsCompatibility: false,
        textTheme: Theme.of(context).textTheme,
        // color: Color.fromARGB(255, 34, 34, 34), //default appBar color
      ),

      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        brightness: Brightness.dark,
      ),

      //ToDo: note the trick and the bug with color scheme :(

      textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: fontFactor,
            fontSizeDelta: 0,
            //the solution is by using ==>
            bodyColor: Colors.white,
            displayColor: Colors.white54,
          ),
      //
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
      //
    );
    return themeData;
  }
}
