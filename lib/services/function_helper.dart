import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/completed_tasks_cubit/completed_tasks_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/ui/shared_ui/build_contact_row.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:to_do_list/services/constants.dart';

import 'date_helper.dart';
import 'db_helper.dart';
import 'notification_helper.dart';

class FunctionHelper {
  //
  static int getIntUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  //
  static bool validateForm({
    required GlobalKey<FormState> formKey,
  }) {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  //
  static Future<void> refreshScreensAfterEditTask(
      BuildContext context,
      HomeScreenState homeScreenPreviousState,
      SearchState searchPreviousState) async {
    //refresh homeScreen
    await BlocProvider.of<HomeScreenCubit>(context)
        .getPreviousState(homeScreenPreviousState);
    //refresh completedTasksScreen
    await BlocProvider.of<CompletedTasksCubit>(context).getCompletedTasks();
    //refresh searchScreen
    await BlocProvider.of<SearchCubit>(context)
        .getPreviousState(searchPreviousState);
  }

  static Future<void> refreshHomeScreen(context) async {
    //refresh home screen, may be a notification
    // arrived and the list not refreshed yet !
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    BlocProvider.of<HomeScreenCubit>(context)
        .getPreviousState(homeScreenPreviousState);
  }

  //
  static Future<bool> isCategoryAlreadyExist(String categoryName) async {
    List<CategoryModel> categoriesList = await DBHelper.getCategories();
    for (int i = 0; i < categoriesList.length; i++) {
      if (categoriesList[i].categoryName == categoryName) {
        return true;
      }
    }
    return false;
  }

  //
  static List generateOrderedTasks(List tasks) {
    final viewedTasks = tasks.reversed.toList();
    return viewedTasks;
  }

  static bool isToGoBack(BuildContext context) {
    final int tasksNumber =
        BlocProvider.of<SelectionCubit>(context).getSelectedTask().length;
    //
    if (tasksNumber != 0) {
      BlocProvider.of<SelectionCubit>(context).disableSelectionMode();
      return false;
    } else {
      return true;
    }
  }

  static bool isSystem24Hour(BuildContext context) {
    return MediaQuery.of(context).alwaysUse24HourFormat;
  }

  static const List<String> timeFormatList = const [
    'System default',
    '24-hour',
    '12-hour',
  ];

  static const List<String> fontSizeList = const [
    'System default',
    'Large',
    'Small',
  ];

  static Future<void> withDeleteOperation(TaskModel task) async {
    await DBHelper.deleteValueById(DBHelper.tasksTableName, task.id);

    if (task.notificationId.isNotEmpty) {
      await NotificationHelper.cancelNotification(task.notificationId);
    }
  }

  static Future<TaskModel> addOrCancelNotification(
      TaskModel task, bool newValue) async {
    int? notificationId;
    //
    if (task.notificationId.isNotEmpty) {
      await NotificationHelper.cancelNotification(task.notificationId);
    }
    if (newValue == false) {
      //
      final bool isValidDate = DateHelper.combineDateAndTime(
              date: task.date, time: task.time, dateParseFormat: k_dateFormat)
          .isAfter(DateTime.now());
      if (isValidDate) {
        notificationId = await DBHelper.getNotificationId();
        //
        await NotificationHelper.createNotification(
          notificationId: notificationId,
          title: task.title,
          date: task.date,
          time: task.time,
          payLoad: 'payLoad',
        );
      }
    }
    //
    final TaskModel editedTask = TaskModel(
      id: task.id,
      notificationId: notificationId == null ? '' : '$notificationId',
      title: task.title,
      details: task.details,
      category: task.category,
      isDone: '$newValue', //bool
      time: task.time,
      date: task.date,
    );
    return editedTask;
  }

//--------------------------------------------------------------------------------
  static Future<void> launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      ToastHelper.showToast(context, 'Could not launch');
      throw 'Could not launch $url';
    }
  }

  static Future<void> reportAProblemOnTap(BuildContext context) async {
    //via email, whatsapp,....etc
    //now it is mail ..
    //
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final brand = androidInfo.brand;
    final model = androidInfo.model;
    final androidVersion = androidInfo.version.release;
    final product = androidInfo.product;
    final supportedAbis = androidInfo.supportedAbis;
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appName = packageInfo.appName;
    final String packageName = packageInfo.packageName;
    final String appVersion = packageInfo.version;
    //
    final String mailSubject =
        '$appName $appVersion\n($packageName), $brand $model $product, $supportedAbis, Android $androidVersion';

    final emailUrl = 'mailto:$contactEmail?subject=$mailSubject';
    //
    final url = emailUrl;
    await FunctionHelper.launchUrl(url, context);
  }

  static Future<void> rateUsOnTap(BuildContext context) async {
    final url = googlePlayAppUrl;
    await FunctionHelper.launchUrl(url, context);
  }

  static Future<void> shareOnTap(BuildContext context) async {
    await Share.share(
      'I highly recommend this app for you $googlePlayAppUrl',
      subject: 'Download It Now !',
    );
  }

  static Future<void> moreAppsOnTap(BuildContext context) async {
    final url = AllAppsUrl;
    await FunctionHelper.launchUrl(url, context);
  }

  static Future getContactDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose a contact way'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildContactRow(
              text: 'Gmail',
              imageSource: 'lib/assets/images/gmail_logo.png',
              onTap: () async {
                final url = 'mailto:$contactEmail?subject=Contact Request';
                await FunctionHelper.launchUrl(url, context);
                Navigator.pop(context);
              },
            ),
            BuildContactRow(
              text: 'WhatsApp',
              imageSource: 'lib/assets/images/whatsapp_logo.png',
              onTap: () async {
                final url = whatsAppUrl;
                await FunctionHelper.launchUrl(url, context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
