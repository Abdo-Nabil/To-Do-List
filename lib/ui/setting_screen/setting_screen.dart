import 'package:flutter/material.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/about_screen/about_screen.dart';
import 'package:to_do_list/ui/setting_screen/build_list_tile_with_icon.dart';
import 'package:to_do_list/ui/setting_screen/build_text_separator.dart';
import 'package:to_do_list/ui/setting_screen/startup_category.dart';
import 'package:to_do_list/ui/setting_screen/theme_mode.dart';
import 'package:to_do_list/ui/setting_screen/time_format.dart';
import 'package:to_do_list/ui/setting_screen/week_starting_day.dart';

import 'color_palette.dart';
import 'font_size.dart';

class SettingScreen extends StatelessWidget {
  static const String routeName = 'SettingScreen';
  //
  // Setting cubits are invoked in side drawer settingOnTap
  //
  @override
  Widget build(BuildContext context) {
    //
    FunctionHelper.refreshHomeScreen(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextSeparator('General'),
                  StartupCategory(),
                  WeekStartingDay(),
                  TimeFormat(),
                  FontSize(),
                  BuildTextSeparator('Theme'),
                  AppThemeMode(),
                  ColorPalette(),
                  BuildTextSeparator('Contact'),
                  BuildListTileWithIcon(
                    text: 'Contact Us',
                    icon: Icons.person,
                    onTap: () async {
                      await FunctionHelper.getContactDialog(context);
                    },
                  ),
                  BuildListTileWithIcon(
                    text: 'Report a problem',
                    icon: Icons.feedback,
                    onTap: () async {
                      await FunctionHelper.reportAProblemOnTap(context);
                    },
                  ),
                  BuildTextSeparator('Support'),
                  BuildListTileWithIcon(
                    text: 'Rate Us',
                    icon: Icons.star_rate,
                    onTap: () async {
                      await FunctionHelper.rateUsOnTap(context);
                    },
                  ),
                  BuildListTileWithIcon(
                    text: 'Share',
                    icon: Icons.share,
                    onTap: () async {
                      await FunctionHelper.shareOnTap(context);
                    },
                  ),
                  //ToDo: add more apps if u have more than 1 app
                  // BuildListTileWithIcon(
                  //   text: 'More apps',
                  //   icon: Icons.get_app,
                  //   onTap: () async {
                  //     await FunctionHelper.moreAppsOnTap(context);
                  //   },
                  // ),
                  BuildListTileWithIcon(
                    text: 'About',
                    icon: Icons.info,
                    onTap: () async {
                      Navigator.of(context).pushNamed(AboutScreen.routeName);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
