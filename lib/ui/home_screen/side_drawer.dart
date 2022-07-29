import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/about_screen/about_screen.dart';
import 'package:to_do_list/ui/categories_manager_screen/categories_manager_screen.dart';
import 'package:to_do_list/ui/completed_tasks_screen/completed_tasks_screen.dart';
import 'package:to_do_list/ui/home_screen/build_side_drawer_divider.dart';
import 'package:to_do_list/ui/home_screen/side_drawer_item.dart';
import 'package:to_do_list/ui/setting_screen/setting_screen.dart';
import 'package:to_do_list/ui/tutorial_screen/tutorial_screen.dart';

class SideDrawer extends StatefulWidget {
  final AppBar appBar;
  SideDrawer(this.appBar);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final ScrollController _scrollController = ScrollController();
  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //----------------------------------------------------
    Future<void> allCategoriesOnTap() async {
      Navigator.pop(context);
      await BlocProvider.of<HomeScreenCubit>(context).getAllCategoriesTasks();
    }

    void completedTasksOnTap() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(CompletedTasksScreen.routeName);
    }

    void categoriesManagerOnTap() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(CategoriesManagerScreen.routeName);
    }

    Future<void> settingOnTap() async {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(SettingScreen.routeName);
    }

    void tutorialOnTap() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(TutorialScreen.routeName);
    }

    //reportAProblemOnTap function is in FunctionHelper class
    //rateUsOnTap function is in FunctionHelper class
    //shareOnTap function is in FunctionHelper class
    //moreAppsOnTap function is in FunctionHelper class

    void aboutOnTap() {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(AboutScreen.routeName);
    }

    //----------------------------------------------------
    final ThemeData themeContext = Theme.of(context);
    return Container(
      // width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top, //status bar
              color: themeContext.primaryColor,
            ),
            Container(
              width: double.infinity,
              height: widget.appBar.preferredSize.height * (3 / 2),
              color: themeContext.primaryColor,
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 8),
                  title: Text(
                    'To Do List',
                    style: TextStyle(
                      fontSize: FontHelper.headline6(context).fontSize,
                      fontWeight: FontHelper.headline6(context).fontWeight,
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.check_circle_sharp,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    BuildSideDrawerItem(
                      text: 'All Categories',
                      icon: Icons.home,
                      onTap: () async {
                        await allCategoriesOnTap();
                      },
                    ),
                    BuildSideDrawerItem(
                      text: 'Completed Tasks',
                      icon: Icons.assignment_turned_in,
                      onTap: () {
                        completedTasksOnTap();
                      },
                    ),
                    BuildSideDrawerItem(
                      text: 'Categories Manager',
                      icon: Icons.category_outlined,
                      onTap: () {
                        categoriesManagerOnTap();
                      },
                    ),
                    BuildSideDrawerDivider(),
                    BuildSideDrawerItem(
                      text: 'Setting',
                      icon: Icons.settings,
                      onTap: () async {
                        await settingOnTap();
                      },
                    ),
                    BuildSideDrawerItem(
                      text: 'Tutorial',
                      icon: Icons.menu_book_outlined,
                      onTap: () {
                        tutorialOnTap();
                      },
                    ),
                    BuildSideDrawerItem(
                      text: 'Report a problem',
                      icon: Icons.feedback,
                      onTap: () async {
                        await FunctionHelper.reportAProblemOnTap(context);
                      },
                    ),
                    BuildSideDrawerDivider(),
                    BuildSideDrawerItem(
                      text: 'Rate Us',
                      icon: Icons.star_rate,
                      onTap: () async {
                        await FunctionHelper.rateUsOnTap(context);
                      },
                    ),
                    BuildSideDrawerItem(
                      text: 'Share',
                      icon: Icons.share,
                      onTap: () async {
                        await FunctionHelper.shareOnTap(context);
                      },
                    ),
                    //ToDo: add more apps if u have more than 1 app
                    // BuildSideDrawerItem(
                    //   text: 'More Apps',
                    //   icon: Icons.get_app,
                    //   onTap: () async {
                    //     await FunctionHelper.moreAppsOnTap(context);
                    //   },
                    // ),
                    BuildSideDrawerItem(
                      text: 'About',
                      icon: Icons.info,
                      onTap: () {
                        aboutOnTap();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
