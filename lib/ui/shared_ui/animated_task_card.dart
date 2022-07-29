import 'package:flutter/material.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/ui/shared_ui/task_card.dart';

class AnimatedTaskCard extends StatelessWidget {
  final List allTasks;
  final TaskModel removedTask;
  final animation;
  final bool isGoingToBeDone;
  final TextStyle dateAndTimeTextStyle;

  const AnimatedTaskCard({
    required this.allTasks,
    required this.removedTask,
    required this.animation,
    required this.isGoingToBeDone,
    required this.dateAndTimeTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    //
    TaskModel getAnimatedTask(TaskModel task, bool isGoingToBeDone) {
      String value = 'false';
      if (isGoingToBeDone == true) {
        value = 'true';
      }
      return TaskModel(
        id: task.id,
        title: task.title,
        details: task.details,
        category: task.category,
        isDone: '$value',
        //bool
        time: task.time,
        date: task.date,
      );
    }

    //
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ),
        ),
        child: TaskCard(
          allTasks: allTasks,
          task: getAnimatedTask(removedTask, isGoingToBeDone),
          dateAndTimeTextStyle: dateAndTimeTextStyle,
          onChangeCheckBox: () {},
        ),
      ),
    );
  }
}
