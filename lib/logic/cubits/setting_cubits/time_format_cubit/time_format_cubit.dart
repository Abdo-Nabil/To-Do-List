import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
part 'time_format_state.dart';

class TimeFormatCubit extends Cubit<TimeFormatState> {
  TimeFormatCubit() : super(TimeFormatInitialState());

  //-------------------* const *---------------------------
  String systemDefault = FunctionHelper.timeFormatList[0];
  String format24Hour = FunctionHelper.timeFormatList[1];
  String format12Hour = FunctionHelper.timeFormatList[2];
  //-------------------------------------------------------

  bool _is24HourFormat = false;
  get is24HourFormat => _is24HourFormat;

  Future<void> updateTasksTime(BuildContext context, String newFormat) async {
    List tasks = await DBHelper.getAllTasks();
    tasks.forEach(
      (task) async {
        final String newTime = DateHelper.convertTime(
          time: task.time,
          newFormat: newFormat,
          context: context,
        );
        await DBHelper.updateValue(
          DBHelper.tasksTableName,
          TaskModel(
            id: task.id,
            title: task.title,
            notificationId: task.notificationId,
            details: task.details,
            category: task.category,
            date: task.date,
            isDone: task.isDone,
            time: newTime,
          ),
        );
      },
    );
  }

  Future<void> getTimeFormat(context) async {
    // emit(TimeFormatLoadingState());
    late String timeFormat;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startupTimeFormat = prefs.getString('timeFormat');

    if (startupTimeFormat == null) {
      await prefs.setString('timeFormat', systemDefault);
      _is24HourFormat = FunctionHelper.isSystem24Hour(context);
      timeFormat = systemDefault;
    }
    //
    else if (startupTimeFormat == systemDefault) {
      _is24HourFormat = FunctionHelper.isSystem24Hour(context);
      timeFormat = systemDefault;
      //to change tasks time because the app didn't get notified if it was opened when the system change the time format
      // so after restart the app we change tasks time !
      await updateTasksTime(context, systemDefault);
    } else if (startupTimeFormat == format24Hour) {
      _is24HourFormat = true;
      timeFormat = format24Hour;
    } else {
      _is24HourFormat = false;
      timeFormat = format12Hour;
    }
    emit(GetTimeFormatState(timeFormat));
  }

  Future<void> selectTimeFormat(String timeFormat, BuildContext context) async {
    // emit(TimeFormatLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (timeFormat == systemDefault) {
      await prefs.setString('timeFormat', systemDefault);
      _is24HourFormat = FunctionHelper.isSystem24Hour(context);
      await updateTasksTime(context, systemDefault);
    }
    //
    else if (timeFormat == format24Hour) {
      await prefs.setString('timeFormat', format24Hour);
      _is24HourFormat = true;
      await updateTasksTime(context, format24Hour);
    }
    //
    else {
      await prefs.setString('timeFormat', format12Hour);
      _is24HourFormat = false;
      await updateTasksTime(context, format12Hour);
    }
    emit(GetTimeFormatState(timeFormat));
  }
}
