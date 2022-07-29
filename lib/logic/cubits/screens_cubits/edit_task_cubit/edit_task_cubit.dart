import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/db_helper.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit() : super(EditTaskInitialState());

  late bool _isChecked;
  bool get isChecked => _isChecked;

  void checkTheBox() {
    _isChecked = true;
    emit(CheckedBoxState());
  }

  void unCheckTheBox() {
    _isChecked = false;
    emit(UnCheckedBoxState());
  }

  Future<void> updateTask(TaskModel task) async {
    await DBHelper.updateValue(DBHelper.tasksTableName, task);
  }
}
