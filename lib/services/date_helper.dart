import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/constants.dart';

class DateHelper {
  //Edit what you want ...enjoy !

  static bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static int getIntUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

//------------------------------------------------------------------------------

  static DateTime parseDate(String date, String dateParseFormat) {
    //parseFormat = DateFormat('yyyy-MM-dd')  => 2021-08-20
    //return will be like that : 2021-08-06 00:00:00.000
    return DateFormat(dateParseFormat).parse(date);
  }

  static TimeOfDay parseTime(String time) {
    //DateFormat.jm() => 5:08 PM   <=====>  DateFormat('hh:mm a')
    //DateFormat.Hm() => 17:08     <=====>  DateFormat('HH:mm ')
    if (time.endsWith('M')) {
      //that means that the time is AM or PM => 12-hour format
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
      return timeOfDay;
    }
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateFormat.Hm().parse(time));
    return timeOfDay;
  }

  static bool isPastDate(DateTime date) {
    return DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)
        .isAfter(date);
  }

  static bool isPastDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
    ).isAfter(
      date.add(
        Duration(hours: time.hour, minutes: time.minute),
      ),
    );
  }

//------------------------------------------------------------------------------
  //used for initial time in time picker
  static TimeOfDay getNextHour() {
    return convertDateToTime(
      DateTime(
        0,
        0,
        0,
        DateTime.now().hour + 1,
        0,
      ),
    );
  }

  static DateTime getDatePickerInitialDate(String date) {
    if (date.isEmpty) {
      return DateTime.now();
    }
    return DateHelper.parseDate(date, k_dateFormat);
  }

  static TimeOfDay getTimePickerInitialTime(String time) {
    if (time.isEmpty) {
      return DateHelper.getNextHour();
    }
    return DateHelper.parseTime(time);
  }

//------------------------------------------------------------------------------

  //convert from 12-hour to 24-hour and vice versa
  static String convertTime({
    required String time,
    required String newFormat,
    required BuildContext context,
  }) {
    //DateFormat.jm() => 5:08 PM   <=====>  DateFormat('hh:mm a')
    //DateFormat.Hm() => 17:08     <=====>  DateFormat('HH:mm ')
    if (time.isEmpty) {
      //if task has no date... keep time field as it was,
      return '';
    }
    bool isSystem24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    if (time.endsWith('M') &&
        (newFormat == FunctionHelper.timeFormatList[0] ||
            newFormat == FunctionHelper.timeFormatList[2])) {
      if (isSystem24Hour) {
        TimeOfDay timeOfDay =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
        String returnedTime = MaterialLocalizations.of(context).formatTimeOfDay(
          timeOfDay,
          alwaysUse24HourFormat: true,
        );
        return returnedTime;
      }
      return time;
    }

    if (!time.endsWith('M') &&
        (newFormat == FunctionHelper.timeFormatList[0] ||
            newFormat == FunctionHelper.timeFormatList[1])) {
      if (isSystem24Hour == false) {
        TimeOfDay timeOfDay =
            TimeOfDay.fromDateTime(DateFormat.Hm().parse(time));
        String returnedTime = MaterialLocalizations.of(context).formatTimeOfDay(
          timeOfDay,
          alwaysUse24HourFormat: false,
        );
        return returnedTime;
      }
      return time;
    }
    if (time.endsWith('M')) {
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
      String returnedTime = MaterialLocalizations.of(context).formatTimeOfDay(
        timeOfDay,
        alwaysUse24HourFormat: true,
      );
      return returnedTime;
    }
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateFormat.Hm().parse(time));
    String returnedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: false,
    );
    return returnedTime;
  }

  static DateTime convertTimeToDate(String time) {
    //DateFormat.jm() => 5:08 PM   <=====>  DateFormat('hh:mm a')
    //DateFormat.Hm() => 17:08     <=====>  DateFormat('HH:mm ')

    if (time.endsWith('M')) {
      //that means that the time is AM or PM => 12-hour format
      DateTime dateTime = DateFormat.jm().parse(time);
      return dateTime;
    }
    DateTime dateTime = DateFormat.Hm().parse(time);
    return dateTime;
  }

  static TimeOfDay convertDateToTime(DateTime date) {
    return TimeOfDay.fromDateTime(date);
  }

  static String convertIntDayToString(int day) {
    switch (day) {
      case 1:
        return 'Monday';

      case 2:
        return 'Tuesday';

      case 3:
        return 'Wednesday';

      case 4:
        return 'Thursday';

      case 5:
        return 'Friday';

      case 6:
        return 'Saturday';

      case 7:
        return 'Sunday';
    }
    return 'ERROR IN DATE HELPER CLASS';
  }

  static int convertStringDayToInt(String day) {
    switch (day) {
      case 'Monday':
        return 1;

      case 'Tuesday':
        return 2;

      case 'Wednesday':
        return 3;

      case 'Thursday':
        return 4;

      case 'Friday':
        return 5;

      case 'Saturday':
        return 6;

      case 'Sunday':
        return 7;
    }
    return 0;
  }

//------------------------------------------------------------------------------

  static String getFormattedString({
    required DateTime date,
    required String formattedString,
  }) {
    return DateFormat(formattedString).format(date).toString();
  }

  static DateTime combineDateAndTime({
    required String date,
    required String time,
    required String dateParseFormat,
  }) {
    // if no time selected ..make the time in the end of the day (23 h : 59 m)
    TimeOfDay parsedTime =
        TimeOfDay.fromDateTime(DateTime(1, 1, 1, 23, 59, 59));
    if (time.isNotEmpty) {
      parsedTime = DateHelper.parseTime(time);
    }
    //if no date selected...year 0 , just known value for comparison
    DateTime parsedDate = DateTime(0);
    if (date.isNotEmpty) {
      parsedDate = DateHelper.parseDate(date, dateParseFormat);
    }

    return parsedDate.add(
      Duration(hours: parsedTime.hour, minutes: parsedTime.minute),
    );
  }

  static Duration getDifference({
    required String date,
    required String time,
    required String dateParseFormat,
  }) {
    //if returned value in positive, it means that given date in the future.
    //if returned value in negative, it means that given date in the past.
    if (date.isEmpty) {
      //just a constant Duration of zero to be used in comparison,
      // there is no meaning more than comparing a defined value of 0.
      return Duration();
    }
    DateTime firstDate = DateHelper.parseDate(date, dateParseFormat);
    //firstDate will be like that : 2021-08-06 00:00:00.000
    TimeOfDay parsedTime = DateHelper.parseTime(time);
    //parsedTime will be like that : TimeOfDay(23:44)
    //
    firstDate = DateTime(
      firstDate.year,
      firstDate.month,
      firstDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    DateTime secondDate = DateTime.now();
    //DateTime.now will be like that : 2021-08-06 15:06:22.249621
    Duration duration = firstDate.difference(secondDate);

    return duration;
  }

//----------------------------------------------------------------------------------------

  // all these getters produce DateTime object compared to DateTime.now()
  //
  static DateTime getBeforeYesterdayStartingPoint() {
    final DateTime beforeYesterday =
        DateTime.now().subtract(const Duration(days: 2));
    final DateTime beforeYesterdayStartingPoint = DateTime(beforeYesterday.year,
        beforeYesterday.month, beforeYesterday.day, 0, 0, 0);
    return beforeYesterdayStartingPoint;
  }

  static DateTime getBeforeYesterdayEndingPoint() {
    final DateTime beforeYesterday =
        DateTime.now().subtract(const Duration(days: 2));
    final DateTime beforeYesterdayEndingPoint = DateTime(beforeYesterday.year,
        beforeYesterday.month, beforeYesterday.day, 23, 59, 59);
    return beforeYesterdayEndingPoint;
  }

  static DateTime getYesterdayStartingPoint() {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    final DateTime yesterdayStartingPoint =
        DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    return yesterdayStartingPoint;
  }

  static DateTime getYesterdayEndingPoint() {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    final DateTime yesterdayEndingPoint =
        DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
    return yesterdayEndingPoint;
  }

  static DateTime getTodayStartingPoint() {
    final DateTime current = DateTime.now();
    final DateTime todayStartingPoint =
        DateTime(current.year, current.month, current.day, 0, 0, 0);
    return todayStartingPoint;
  }

  static DateTime getTodayEndingPoint() {
    final DateTime current = DateTime.now();
    final DateTime todayEndingPoint =
        DateTime(current.year, current.month, current.day, 23, 59, 59);
    return todayEndingPoint;
  }

  static DateTime getTomorrowStartingPoint() {
    final DateTime tomorrow = DateTime.now().add(
      Duration(days: 1),
    );
    final DateTime tomorrowStartingPoint =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0);
    return tomorrowStartingPoint;
  }

  static DateTime getTomorrowEndingPoint() {
    final DateTime tomorrow = DateTime.now().add(
      Duration(days: 1),
    );
    final DateTime tomorrowEndingPoint =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59);
    return tomorrowEndingPoint;
  }

  static DateTime getThisWeekStartingPoint(int weekStartingDay) {
    final DateTime current = DateTime.now();
    final int currentDay = DateTime.now().weekday; //monday=1, tuesday = 2,.....
    if (currentDay == weekStartingDay) {
      final DateTime weekStartingPoint = DateTime(
        current.year,
        current.month,
        current.day,
        0,
        0,
        0,
      );
      return weekStartingPoint;
    } else {
      final int difference = (currentDay - weekStartingDay + 7) % 7;
      final DateTime currentWeekStartingDay = current.subtract(
        Duration(days: difference),
      );
      final DateTime thisWeekStartingPoint = DateTime(
        currentWeekStartingDay.year,
        currentWeekStartingDay.month,
        currentWeekStartingDay.day,
        0,
        0,
        0,
      );
      return thisWeekStartingPoint;
    }
  }

  static DateTime getThisWeekEndingPoint(int weekStartingDay) {
    final current = DateTime.now();
    final int currentDay = DateTime.now().weekday; //monday=1, tuesday = 2,.....
    if (currentDay == weekStartingDay) {
      final DateTime endDate = current.add(Duration(days: 6));
      final DateTime thisWeekEndingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      return thisWeekEndingPoint;
    } else {
      final int difference = (currentDay - weekStartingDay + 7) % 7;
      final DateTime currentWeekStartingDay = current.subtract(
        Duration(days: difference),
      );
      final DateTime endDate = currentWeekStartingDay.add(Duration(days: 6));
      final DateTime thisWeekEndingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      return thisWeekEndingPoint;
    }
  }

  static DateTime getNextWeekStartingPoint(int weekStartingDay) {
    final current = DateTime.now();
    final int currentDay = DateTime.now().weekday; //monday=1, tuesday = 2,.....
    if (currentDay == weekStartingDay) {
      final DateTime endDate = current.add(Duration(days: 7));
      final DateTime nextWeekStartingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        0,
        0,
        0,
      );
      return nextWeekStartingPoint;
    } else {
      final int difference = (currentDay - weekStartingDay + 7) % 7;
      final DateTime currentWeekStartingDay = current.subtract(
        Duration(days: difference),
      );
      final DateTime endDate = currentWeekStartingDay.add(Duration(days: 7));
      final DateTime nextWeekStartingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        0,
        0,
        0,
      );
      return nextWeekStartingPoint;
    }
  }

  static DateTime getNextWeekEndingPoint(int weekStartingDay) {
    final current = DateTime.now();
    final int currentDay = DateTime.now().weekday; //monday=1, tuesday = 2,.....
    if (currentDay == weekStartingDay) {
      final DateTime endDate = current.add(Duration(days: 13));
      final DateTime nextWeekEndingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      return nextWeekEndingPoint;
    } else {
      final int difference = (currentDay - weekStartingDay + 7) % 7;
      final DateTime currentWeekStartingDay = current.subtract(
        Duration(days: difference),
      );
      final DateTime endDate = currentWeekStartingDay.add(Duration(days: 13));
      final DateTime nextWeekEndingPoint = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      return nextWeekEndingPoint;
    }
  }

  static DateTime getThisMonthStartingPoint() {
    final current = DateTime.now();
    final DateTime thisMonthStartingPoint = DateTime(
      current.year,
      current.month,
      1,
      0,
      0,
      0,
    );
    return thisMonthStartingPoint;
  }

  static DateTime getThisMonthEndingPoint() {
    //                   Month	                                 Total days

    // January, March, May, July, August, October, December	       31 days
    //    1       3     5     7     8        10      12

    // February	                                                 28/29 days
    //    2

    // April, June, September, November	                           30 days
    //   4      6      9          11

    final current = DateTime.now();
    final int currentMonth =
        DateTime.now().month; //january=1, february = 2,.....
    final bool isLeap =
        isLeapYear(current.year); //it has 366 days instead of 365 ??
    //
    if (currentMonth == DateTime.april ||
        currentMonth == DateTime.june ||
        currentMonth == DateTime.september ||
        currentMonth == DateTime.november) {
      final DateTime thisMonthEndingPoint = DateTime(
        current.year,
        current.month,
        30, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return thisMonthEndingPoint;
    }
    //
    if (currentMonth == DateTime.february && isLeap) {
      final DateTime thisMonthEndingPoint = DateTime(
        current.year,
        current.month,
        29, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return thisMonthEndingPoint;
    }
    //
    if (currentMonth == DateTime.february && isLeap == false) {
      final DateTime thisMonthEndingPoint = DateTime(
        current.year,
        current.month,
        28, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return thisMonthEndingPoint;
    }
    //any month otherwise =>
    return DateTime(
      current.year,
      current.month,
      31, //days
      23, //hours
      59, //minutes
      59, //seconds
    );
  }

  static DateTime getNextMonthStartingPoint() {
    final DateTime nextMonth = getThisMonthEndingPoint()
        .add(Duration(days: 1)); //add one day to get the next month
    final DateTime nextMonthStartingPoint = DateTime(
      nextMonth.year,
      nextMonth.month,
      1,
      0,
      0,
      0,
    );
    return nextMonthStartingPoint;
  }

  static DateTime getNextMonthEndingPoint() {
    //                   Month	                                 Total days

    // January, March, May, July, August, October, December	       31 days
    //    1       3     5     7     8        10      12

    // February	                                                 28/29 days
    //    2

    // April, June, September, November	                           30 days
    //   4      6      9          11

    final current = DateTime.now();
    final DateTime nextMonth = getThisMonthEndingPoint()
        .add(Duration(days: 1)); //add one day to get the next month
    final int nextMonthName = getThisMonthEndingPoint()
        .add(Duration(days: 1))
        .month; //january=1, february = 2,.....
    final bool isLeap =
        isLeapYear(current.year); //has 366 days instead of 365.25
    //
    if (nextMonthName == DateTime.april ||
        nextMonthName == DateTime.june ||
        nextMonthName == DateTime.september ||
        nextMonthName == DateTime.november) {
      final DateTime nextMonthEndingPoint = DateTime(
        nextMonth.year,
        nextMonth.month,
        30, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return nextMonthEndingPoint;
    }
    //
    if (nextMonthName == DateTime.february && isLeap) {
      final DateTime nextMonthEndingPoint = DateTime(
        nextMonth.year,
        nextMonth.month,
        29, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return nextMonthEndingPoint;
    }
    //
    if (nextMonthName == DateTime.february && isLeap == false) {
      final DateTime nextMonthEndingPoint = DateTime(
        nextMonth.year,
        nextMonth.month,
        28, //days
        23, //hours
        59, //minutes
        59, //seconds
      );
      return nextMonthEndingPoint;
    }
    //any month otherwise =>
    return DateTime(
      current.year,
      current.month,
      31, //days
      23, //hours
      59, //minutes
      59, //seconds
    );
  }

  static DateTime getThisYearStartingPoint() {
    final DateTime current = DateTime.now();
    final DateTime thisYearStartingPoint = DateTime(
      current.year,
      1,
      1,
      0,
      0,
      0,
    );
    return thisYearStartingPoint;
  }

  static DateTime getThisYearEndingPoint() {
    final DateTime current = DateTime.now();
    final DateTime thisYearEndingPoint = DateTime(
      current.year,
      12,
      31,
      23,
      59,
      59,
    );
    return thisYearEndingPoint;
  }

  static DateTime getNextYearStartingPoint() {
    final bool isLeap = isLeapYear(DateTime.now().year);
    if (isLeap) {
      //if current year is leap, this means that to get the next year you have to add 366 days instead of 365 days
      final DateTime nextYear = DateTime.now().add(Duration(days: 366));
      final DateTime nextYearStartingPoint = DateTime(
        nextYear.year,
        1,
        1,
        0,
        0,
        0,
      );
      return nextYearStartingPoint;
    }
    //
    final DateTime nextYear = DateTime.now().add(Duration(days: 365));
    final DateTime nextYearStartingPoint = DateTime(
      nextYear.year,
      1,
      1,
      0,
      0,
      0,
    );

    return nextYearStartingPoint;
  }

  static DateTime getNextYearEndingPoint() {
    final bool isLeap = isLeapYear(DateTime.now().year);
    if (isLeap) {
      //if current year is leap, this means that to get the next year you have to add 366 days instead of 365 days
      final DateTime nextYear = DateTime.now().add(Duration(days: 366));
      final DateTime nextYearEndingPoint = DateTime(
        nextYear.year,
        12,
        31,
        23,
        59,
        59,
      );
      return nextYearEndingPoint;
    }
    //
    final DateTime nextYear = DateTime.now().add(Duration(days: 365));
    final DateTime nextYearEndingPoint = DateTime(
      nextYear.year,
      12,
      31,
      23,
      59,
      59,
    );
    return nextYearEndingPoint;
  }

// -----------------------* Some Styling *----------------------------------------------------------

  //used in CardItem to decide if date and time is red or not
  // isPreviousTask = true => just used in overdue tasks
  static TextStyle getDateAndTimeTextStyle({
    required BuildContext context,
    required bool isPreviousTask,
  }) {
    TextStyle style = TextStyle(
      fontSize: FontHelper.bodyText2Default(context).fontSize,
      color: Theme.of(context).accentColor,
    );
    if (isPreviousTask) {
      style = FontHelper.errorBodyText2Default(context);
    }
    return style;
  }

  //used in DatePicker and TimePicker
  //used to show yesterday, today or tomorrow in NewTaskScreen, EditTaskScreen and HomeScreen
  // instead of showing the real date of today !
  static List getDateAndStyle(
      {required givenDate, required BuildContext context}) {
    late String date;
    late TextStyle style;
    //
    if (givenDate.isEmpty) {
      date = k_date_not_set_phrase;
      style = FontHelper.greySubtitle1Default(context);
    } else {
      final DateTime dateTime = DateHelper.parseDate(givenDate, k_dateFormat);
      //today
      if (dateTime.isAfter(DateHelper.getYesterdayEndingPoint()) &&
          dateTime.isBefore(DateHelper.getTodayEndingPoint())) {
        date = 'Today';
        style = FontHelper.subtitle1Default(context);
      }
      //tomorrow
      else if (dateTime.isAfter(DateHelper.getTodayEndingPoint()) &&
          dateTime.isBefore(DateHelper.getTomorrowEndingPoint())) {
        date = 'Tomorrow';
        style = FontHelper.subtitle1Default(context);
      }
      //yesterday
      else if (dateTime.isAfter(DateHelper.getBeforeYesterdayEndingPoint()) &&
          dateTime.isBefore(DateHelper.getYesterdayEndingPoint())) {
        date = 'Yesterday';
        style = FontHelper.errorSubtitle1Default(context);
      }
      //
      else if (dateTime.isBefore(DateHelper.getYesterdayStartingPoint())) {
        date = DateHelper.getFormattedString(
            date: dateTime, formattedString: k_dateFormat);
        style = FontHelper.errorSubtitle1Default(context);
      }
      //any other date
      else {
        date = DateHelper.getFormattedString(
            date: dateTime, formattedString: k_dateFormat);
        style = FontHelper.subtitle1Default(context);
      }
    }
    return [date, style];
  }

  static List getTimeAndStyle(
      {required String givenTime,
      required String givenDate,
      required BuildContext context}) {
    late String time;
    late TextStyle style;

    if (givenTime.isEmpty) {
      time = k_time_not_set_phrase;
      style = FontHelper.greySubtitle1Default(context);
    } else {
      final DateTime dateAndTime = DateHelper.combineDateAndTime(
        time: givenTime,
        date: givenDate,
        dateParseFormat: k_dateFormat,
      );
      if (dateAndTime.isBefore(DateTime.now())) {
        time = givenTime;
        style = FontHelper.errorSubtitle1Default(context);
      } else {
        time = givenTime;
        style = FontHelper.subtitle1Default(context);
      }
    }
    return [time, style];
  }

//-----------------------------------------------------------------------------------------------

}
