import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/function_helper.dart';

part 'completed_tasks_state.dart';

class CompletedTasksCubit extends Cubit<CompletedTasksState> {
  CompletedTasksCubit() : super(CompletedTasksInitialState());

  Future<void> updateTaskCardCheckBox(TaskModel task, bool newValue) async {
    final editedTask =
        await FunctionHelper.addOrCancelNotification(task, newValue);

    await DBHelper.updateValue(
      DBHelper.tasksTableName,
      editedTask,
    );
  }

  Future<void> getCompletedTasks() async {
    emit(CompletedTasksLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    List tasks = await DBHelper.getCompletedTasks();
    emit(GetCompletedTasksState(tasks));
  }
}
