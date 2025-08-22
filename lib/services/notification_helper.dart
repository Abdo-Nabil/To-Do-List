import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'date_helper.dart';

class NotificationHelper {
  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  static Future<void> initializeNotification() async {
    //Initialise the time zone database
    tz.initializeTimeZones();
    // initialize the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    //
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  static Future selectNotification(String? payload) async {
    print('**************** payload : $payload!!!');

    /* AwesomeNotifications().actionStream.listen(
      (receivedNotification) {
        print(receivedNotification);
        final TaskModel scheduledTask = TaskModel.fromMap(
          receivedNotification.payload as Map<String, dynamic>,
        );
        //notification itself pressed or EDIT button pressed
        if (receivedNotification.buttonKeyPressed == 'EDIT' ||
            receivedNotification.buttonKeyPressed.isEmpty) {
          //

          Navigator.pushNamed(
            context,
            EditTaskScreen.routeName,
            arguments: scheduledTask,
          );
          //Mark as finished button pressed
        } else if (receivedNotification.buttonKeyPressed == 'FINISH') {
          BlocProvider.of<TaskBloc>(context).add(
            UpdateTaskEvent(
              TaskModel(
                id: scheduledTask.id,
                title: scheduledTask.title,
                details: scheduledTask.details,
                category: scheduledTask.category,
                date: scheduledTask.date,
                time: scheduledTask.time,
                isDone: 'true',
              ),
            ),
          );
        }
      },
    ); */
  }

  static createNotification({
    required int notificationId,
    required String title,
    required String date,
    required String time,
    required String? payLoad,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel id',
      'Basic Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    final DateTime scheduledDate = DateHelper.combineDateAndTime(
      date: date,
      time: time,
      dateParseFormat: k_dateFormat,
    );
    // print('**********************${tz.local}');
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      notificationId,
      title,
      time,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payLoad,
    );

    print('******** Notification Created Successfully');
    /*await FlutterLocalNotificationsPlugin().show(
      notificationId,
      title,
      time,
      platformChannelSpecifics,
      payload: payLoad,
    );*/
    /*
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: title,
        body: time,
        icon: 'resource://drawable/foo',
        payload: payLoad,
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateHelper.combineDateAndTime(
          date: date,
          time: time,
          dateParseFormat: k_dateFormat,
          is24HourFormat: false,
          defaultHour: 10,
          defaultMinute: 30,
        ),
      ),
      actionButtons: [
        NotificationActionButton(
          enabled: true,
          key: 'EDIT',
          label: 'EDIT',
        ),
        NotificationActionButton(
          enabled: true,
          key: 'FINISH',
          label: 'Mark as finished',
          buttonType: ActionButtonType.KeepOnTop,
        ),
      ],
    );*/
  }

  static Future<void> cancelNotification(String notificationId) async {
    // print('notificationId : $notificationId');
    //
    try {
      await FlutterLocalNotificationsPlugin().cancel(
        int.parse(notificationId),
      );
      print('******** Notification Canceled Successfully');
    } catch (error) {
      print('-------------------* Notification not found !! *-------------');
    }
  }
  //   final List<PendingNotificationRequest> pendingNotificationRequests =
  //       await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
  //   List<int> notificationIds = [];
  //   for (int i = 0; i < pendingNotificationRequests.length; i++) {
  //     notificationIds.add(pendingNotificationRequests[i].id);
  //   }
  //   //
  //   if (notificationIds.contains(int.parse(notificationId))) {
  //     await FlutterLocalNotificationsPlugin().cancel(
  //       int.parse(notificationId),
  //     );
  //     print('******** Notification Canceled Successfully');
  //   } else {
  //     print('-------------* Notification Id is not found !! *-------------');
  //   }
  // }
}
