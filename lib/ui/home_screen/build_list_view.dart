import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/time_format_cubit/time_format_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/week_first_day_cubit/week_starting_day_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/constants.dart';

import 'home_screen_date_section.dart';

class BuildListView extends StatelessWidget {
  final List tasks;

  BuildListView(
    this.tasks,
  );

  @override
  Widget build(BuildContext context) {
    print('*********************** build listView rebuilt !');
    //some settings
    String dateParseFormat = k_dateFormat;
    bool is24HourFormat =
        BlocProvider.of<TimeFormatCubit>(context).is24HourFormat;
    int weekStartingDay =
        BlocProvider.of<WeekStartingDayCubit>(context).weekStartingDay;

    Color unFinishedTasksTitleColor = Theme.of(context).errorColor;
    Color noDateTasksTitleColor = Theme.of(context).hintColor;
    Color otherTasksTitleColor = Theme.of(context).accentColor;
    //
    List getOverdueTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final DateTime taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          //
          final yearOfZero = DateTime(0);
          //
          return taskDateAndTime.isBefore(DateTime.now()) &&
              //if no time is selected the time will be DateTime(0)
              taskDateAndTime.year != yearOfZero.year;
        },
      ).toList();
    }

    //
    List getTodayTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final DateTime todayEndingPoint = DateHelper.getTodayEndingPoint();
          final DateTime taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );

          final returnedValue = taskDateAndTime.isBefore(todayEndingPoint) &&
              taskDateAndTime.isAfter(DateTime.now());

          return returnedValue;
        },
      ).toList();
    }

    //
    List getTomorrowTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final DateTime todayEndingPoint = DateHelper.getTodayEndingPoint();
          ;
          final DateTime tomorrowEndingPoint =
              DateHelper.getTomorrowEndingPoint();

          final DateTime taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );

          final returnedValue = taskDateAndTime.isBefore(tomorrowEndingPoint) &&
              taskDateAndTime.isAfter(todayEndingPoint);

          return returnedValue;
        },
      ).toList();
    }

    //
    List getThisWeekTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
      required int weekStartingDay,
    }) {
      return tasks.where((task) {
        final taskDateAndTime = DateHelper.combineDateAndTime(
          date: task.date,
          time: task.time,
          dateParseFormat: dateParseFormat,
        );
        //
        final DateTime thisWeekendingPoint =
            DateHelper.getThisWeekEndingPoint(weekStartingDay);
        //
        final DateTime tomorrowEndingPoint =
            DateHelper.getTomorrowEndingPoint();
        //
        return taskDateAndTime.isBefore(thisWeekendingPoint) &&
            taskDateAndTime.isAfter(tomorrowEndingPoint);
      }).toList();
    }

    //
    List getNextWeekTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
      required int weekStartingDay,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          final DateTime nextWeekEndingPoint =
              DateHelper.getNextWeekEndingPoint(weekStartingDay);
          //
          final DateTime thisWeekEndingPoint =
              DateHelper.getThisWeekEndingPoint(weekStartingDay);
          //
          return taskDateAndTime.isBefore(nextWeekEndingPoint) &&
              taskDateAndTime.isAfter(thisWeekEndingPoint);
        },
      ).toList();
    }

    List getThisMonthTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
      required int weekStartingDay,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          final DateTime thisMonthEndingPoint =
              DateHelper.getThisMonthEndingPoint();
          //
          final DateTime nextWeekEndingPoint =
              DateHelper.getNextWeekEndingPoint(weekStartingDay);
          //
          return taskDateAndTime.isBefore(thisMonthEndingPoint) &&
              taskDateAndTime.isAfter(nextWeekEndingPoint);
        },
      ).toList();
    }

    List getNextMonthTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          final DateTime nextMonthEndingPoint =
              DateHelper.getNextMonthEndingPoint();
          //
          final DateTime nextWeekEndingPoint =
              DateHelper.getNextWeekEndingPoint(weekStartingDay);
          //
          final DateTime thisMonthEndingPoint =
              DateHelper.getThisMonthEndingPoint();
          //
          return taskDateAndTime.isBefore(nextMonthEndingPoint) &&
              taskDateAndTime.isAfter(nextWeekEndingPoint) &&
              taskDateAndTime.isAfter(thisMonthEndingPoint);
        },
      ).toList();
    }

    List getThisYearTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );

          final DateTime thisYearEndingPoint =
              DateHelper.getThisYearEndingPoint();
          //
          final DateTime nextMonthEndingPoint =
              DateHelper.getNextMonthEndingPoint();
          //
          return taskDateAndTime.isBefore(thisYearEndingPoint) &&
              taskDateAndTime.isAfter(nextMonthEndingPoint);
        },
      ).toList();
    }

    List getNextYearTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );

          final DateTime nextYearEndingPoint =
              DateHelper.getNextYearEndingPoint();
          //
          final DateTime thisYearEndingPoint =
              DateHelper.getThisYearEndingPoint();
          //

          return taskDateAndTime.isBefore(nextYearEndingPoint) &&
              taskDateAndTime.isAfter(thisYearEndingPoint);
        },
      ).toList();
    }

    List getLaterTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          //
          final DateTime nextYearEndingPoint =
              DateHelper.getNextYearEndingPoint();
          //
          return taskDateAndTime.isAfter(nextYearEndingPoint);
        },
      ).toList();
    }

    List getNoDateTasks({
      required List tasks,
      required String dateParseFormat,
      required bool is24HourFormat,
    }) {
      return tasks.where(
        (task) {
          final taskDateAndTime = DateHelper.combineDateAndTime(
            date: task.date,
            time: task.time,
            dateParseFormat: dateParseFormat,
          );
          //
          final DateTime yearOfZero = DateTime(0);
          //
          return taskDateAndTime.year == yearOfZero.year;
        },
      ).toList();
    }

    return Scrollbar(
      // isAlwaysShown: true,
      child: ListView(
        children: [
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getOverdueTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Overdue',
            sectionNameColor: unFinishedTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: true),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getTodayTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Today',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getTomorrowTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Tomorrow',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getThisWeekTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
              weekStartingDay: weekStartingDay,
            ),
            sectionName: 'This week',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getNextWeekTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
              weekStartingDay: weekStartingDay,
            ),
            sectionName: 'Next week',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getThisMonthTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
              weekStartingDay: weekStartingDay,
            ),
            sectionName: 'This month',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getNextMonthTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Next month',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getThisYearTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'This year',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getNextYearTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Next year',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getLaterTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'Later',
            sectionNameColor: otherTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
          HomeScreenDateSection(
            allTasks: tasks,
            tasks: getNoDateTasks(
              tasks: tasks,
              dateParseFormat: dateParseFormat,
              is24HourFormat: is24HourFormat,
            ),
            sectionName: 'No date',
            sectionNameColor: noDateTasksTitleColor,
            dateAndTimeTextStyle: DateHelper.getDateAndTimeTextStyle(
                context: context, isPreviousTask: false),
          ),
        ],
      ),
    );
  }
}
