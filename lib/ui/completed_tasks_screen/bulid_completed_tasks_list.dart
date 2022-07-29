import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/completed_tasks_cubit/completed_tasks_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/ui/shared_ui/animated_task_card.dart';
import 'package:to_do_list/ui/shared_ui/task_card.dart';
import 'package:to_do_list/services/constants.dart';

class BuildCompletedTasksList extends StatefulWidget {
  final List tasks;

  const BuildCompletedTasksList({
    required this.tasks,
  });

  @override
  _BuildCompletedTasksListState createState() =>
      _BuildCompletedTasksListState();
}

class _BuildCompletedTasksListState extends State<BuildCompletedTasksList> {
  @override
  Widget build(BuildContext context) {
    //
    List tasks = widget.tasks;
    //
    return Scrollbar(
      // isAlwaysShown: true,
      child: AnimatedList(
        initialItemCount: tasks.length,
        itemBuilder: (context, index, animation) {
          //
          final bool isPreviousTask = DateHelper.combineDateAndTime(
                  date: tasks[index].date,
                  time: tasks[index].time,
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
              task: tasks[index],
              dateAndTimeTextStyle: dateAndTimeTextStyle,
              onChangeCheckBox: (newValue) async {
                //-----* some code has been executed in the card_check_box *-----
                final removedTask = tasks.removeAt(index);
                //
                //wait until check box animation ends
                await Future.delayed(
                    Duration(milliseconds: k_check_box_animation_duration));
                //
                AnimatedList.of(context).removeItem(
                  index,
                  (context, animation) {
                    return AnimatedTaskCard(
                      allTasks: tasks,
                      removedTask: removedTask,
                      animation: animation,
                      isGoingToBeDone: false,
                      dateAndTimeTextStyle: dateAndTimeTextStyle,
                    );
                  },
                  duration: Duration(
                      milliseconds: k_removing_task_animation_duration),
                );
                //
                await BlocProvider.of<CompletedTasksCubit>(context)
                    .updateTaskCardCheckBox(removedTask, newValue);
                //
                if (tasks.length == 0) {
                  await Future.delayed(Duration(
                      milliseconds: k_removing_task_animation_duration));

                  await BlocProvider.of<CompletedTasksCubit>(context)
                      .getCompletedTasks();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
