import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/ui/edit_task_screen/edit_task_screen.dart';
import 'package:to_do_list/ui/home_screen/card_check_box.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';

class TaskCard extends StatelessWidget {
  final List allTasks;
  final TaskModel task;
  final TextStyle dateAndTimeTextStyle;
  final Function onChangeCheckBox;
  TaskCard({
    required this.allTasks,
    required this.task,
    required this.dateAndTimeTextStyle,
    required this.onChangeCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    //
    onLongPress() {
      BlocProvider.of<SelectionCubit>(context).selectAndDeSelectTask(task);
    }

    //
    onTap() {
      if (allTasks.any((task) => task.isSelected)) {
        BlocProvider.of<SelectionCubit>(context).selectAndDeSelectTask(task);
      }
      //go to EditTaskScreen
      else {
        Navigator.pushNamed(
          context,
          EditTaskScreen.routeName,
          arguments: task,
        );
        //show time picker if date was selected
        BlocProvider.of<DateAndTimeCubit>(context).checkTimePicker();
      }
    }

    final ThemeData themeContext = Theme.of(context);

    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        //we doesn't use state.blabla, so we can make the following ==>
        // we also do that to remove equitable and repetition and the code
        if (state is EnableSelectionModeState ||
            state is DisableSelectionModeState ||
            state is SelectionInitialState) {
          return InkWell(
            onLongPress: () {
              onLongPress();
            },
            onTap: () {
              onTap();
            },
            child: Card(
              //some of the shape of card implemented in themes
              color: task.isSelected
                  ? themeContext.primaryColorLight.withAlpha(255)
                  : themeContext.cardTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  width: 2,
                  color: Theme.of(context).accentColor,
                  style: task.isSelected ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: CardCheckBox(
                        task: task,
                        onChangeCheckBox: (newValue) {
                          onChangeCheckBox(newValue);
                        },
                        key: Key(task.id),
                      ),
                    ),
                    //use Expanded to fix render overflow,if u use text overflow without Expanded the problem will still
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveSizedBox(
                            heightRatio: 0.015,
                          ),
                          Text(
                            task.title,
                            style: FontHelper.subtitle1W500(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                          ResponsiveSizedBox(
                            heightRatio: 0.004,
                          ),
                          Row(
                            children: [
                              task.date.isNotEmpty
                                  ? Expanded(
                                      child: Text(
                                        '${DateHelper.getDateAndStyle(givenDate: task.date, context: context)[0]} ${task.time.isEmpty ? '' : ','} ${task.time}',
                                        style: dateAndTimeTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          ResponsiveSizedBox(
                            heightRatio: 0.004,
                          ),
                          Text(
                            task.category,
                            style: FontHelper.bodyText2Default(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                          ResponsiveSizedBox(
                            heightRatio: 0.015,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        //
        return ErrorBloc();
      },
    );
  }
}
