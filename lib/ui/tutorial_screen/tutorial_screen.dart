import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/home_screen/home_screen.dart';

class TutorialScreen extends StatelessWidget {
  static const String routeName = 'TutorialScreen';
  @override
  Widget build(BuildContext context) {
    //
    FunctionHelper.refreshHomeScreen(context);
    //
    final double phoneHeight = MediaQuery.of(context).size.height;
    //
    PageDecoration pageDecoration = PageDecoration(
      imagePadding: EdgeInsets.only(
        top: phoneHeight * 0.05,
        right: 8,
        left: 8,
      ),
      titleTextStyle: TextStyle(
        fontSize: FontHelper.headline6(context).fontSize,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: FontHelper.subtitle1Default(context).fontSize,
        fontWeight: FontWeight.normal,
      ),
      titlePadding: EdgeInsets.only(
        top: phoneHeight * 0.12,
        right: 8,
        left: 8,
      ),
      descriptionPadding: EdgeInsets.only(
        top: phoneHeight * 0.05,
        right: 8,
        left: 8,
      ),
    );
    //
    return Scaffold(
      body: IntroductionScreen(
        isBottomSafeArea: true,
        isTopSafeArea: true,
        doneColor: Colors.blue,
        skipColor: Colors.blue,
        nextColor: Colors.blue,
        showDoneButton: true,
        done: Text(
          'Done',
        ),
        onDone: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('storedRoute', 'anyValueNotEqualNull');
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        },
        showSkipButton: true,
        skip: Text(
          'Skip',
        ),
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
            //activeColor: Theme.of(context).accentColor,
            ),
        pages: [
          PageViewModel(
            title: 'Manage Your Tasks',
            body: 'Simply Add, Edit and Delete your To Do list',
            image: Image.asset(
              'lib/assets/images/task.png',
              fit: BoxFit.cover,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Notifications',
            body:
                'Schedule your tasks, set date and time and get notifications on time',
            image: Image.asset(
              'lib/assets/images/notification.png',
              fit: BoxFit.cover,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Dark Mode',
            body: 'Enjoy using dark mode',
            image: Image.asset(
              'lib/assets/images/dark_mode.png',
              fit: BoxFit.cover,
            ),
            decoration: pageDecoration,
          ),
        ],
      ),
    );
  }
}
