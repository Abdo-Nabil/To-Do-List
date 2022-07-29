import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/db_helper.dart';

part 'new_task_state.dart';

class NewTaskCubit extends Cubit<NewTaskState> {
  NewTaskCubit() : super(NewTaskInitialState());

  Future<void> addTask(TaskModel task) async {
    await DBHelper.insertValue(DBHelper.tasksTableName, task);
  }
}
