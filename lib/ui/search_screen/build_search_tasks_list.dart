import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/ui/shared_ui/task_card.dart';
import 'package:to_do_list/services/constants.dart';

class BuildSearchTasksList extends StatelessWidget {
  final List tasks;
  const BuildSearchTasksList({
    required this.tasks,
  });
  Widget build(BuildContext context) {
    //
    return Scrollbar(
      // isAlwaysShown: true,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          //
          final task = tasks[index];
          final bool isPreviousTask = DateHelper.combineDateAndTime(
                  date: task.date,
                  time: task.time,
                  dateParseFormat: k_dateFormat)
              .isBefore(DateTime.now());

          final TextStyle dateAndTimeTextStyle =
              DateHelper.getDateAndTimeTextStyle(
                  context: context, isPreviousTask: isPreviousTask);
          //
          return Padding(
            //just add padding to first item for good UI
            padding: EdgeInsets.fromLTRB(
              0,
              index == 0 ? 6 : 0,
              0,
              0,
            ),
            child: TaskCard(
              allTasks: tasks,
              task: task,
              dateAndTimeTextStyle: dateAndTimeTextStyle,
              onChangeCheckBox: (newValue) async {
                //-----* some code has been executed in the card_check_box *-----
                await BlocProvider.of<SearchCubit>(context)
                    .updateTask(task, newValue);
              },
            ),
          );
        },
      ),
    );
  }
}
