import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/ui/shared_ui/animated_task_card.dart';
import 'package:to_do_list/ui/shared_ui/task_card.dart';
import 'package:to_do_list/services/constants.dart';

class HomeScreenDateSection extends StatefulWidget {
  final List allTasks;
  final List tasks;
  final String sectionName;
  final Color sectionNameColor;
  final TextStyle dateAndTimeTextStyle;

  const HomeScreenDateSection({
    required this.allTasks,
    required this.tasks,
    required this.sectionName,
    required this.sectionNameColor,
    required this.dateAndTimeTextStyle,
  });

  @override
  _HomeScreenDateSectionState createState() => _HomeScreenDateSectionState();
}

class _HomeScreenDateSectionState extends State<HomeScreenDateSection> {
  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    List tasks = widget.tasks;
    //
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        (tasks.length != 0)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.sectionName,
                  style: TextStyle(
                    fontSize: FontHelper.subtitle1Bold(context).fontSize,
                    fontWeight: FontHelper.subtitle1Bold(context).fontWeight,
                    color: widget.sectionNameColor,
                  ),
                ),
              )
            : Container(),
        //in animated list you must make a delay after progress indicator
        // may be 10 milliseconds to give a time for the animated list to be built
        // unlike the listview.builder
        (tasks.length != 0)
            ? AnimatedList(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                initialItemCount: tasks.length,
                itemBuilder: (context, index, animation) {
                  return TaskCard(
                    allTasks: widget.allTasks,
                    task: tasks[index],
                    dateAndTimeTextStyle: widget.dateAndTimeTextStyle,
                    onChangeCheckBox: (newValue) async {
                      //-----* some code has been executed in the card_check_box *-----
                      //
                      final removedTask = tasks.removeAt(index);
                      //
                      //wait until check box animation ends
                      await Future.delayed(Duration(
                          milliseconds: k_check_box_animation_duration));
                      //
                      AnimatedList.of(context).removeItem(
                        index,
                        (context, animation) {
                          return AnimatedTaskCard(
                            allTasks: tasks,
                            removedTask: removedTask,
                            animation: animation,
                            isGoingToBeDone: true,
                            dateAndTimeTextStyle: widget.dateAndTimeTextStyle,
                          );
                        },
                        duration: Duration(
                            milliseconds: k_removing_task_animation_duration),
                      );

                      await BlocProvider.of<HomeScreenCubit>(context)
                          .updateTaskCardCheckBox(removedTask, newValue);

                      //for tasks under specific date section
                      if (tasks.length == 0) {
                        await Future.delayed(Duration(
                            milliseconds: k_removing_task_animation_duration));
                        setState(() {});
                      }

                      //for tasks under all date sections (whole screen)
                      if (BlocProvider.of<HomeScreenCubit>(context)
                              .tasks
                              .length ==
                          0) {
                        await BlocProvider.of<HomeScreenCubit>(context)
                            .getPreviousState(homeScreenPreviousState);
                      }
                    },
                  );
                },
              )
            : Container(),

        //
      ],
    );
  }
}
