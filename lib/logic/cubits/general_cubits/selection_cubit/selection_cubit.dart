import 'package:bloc/bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/notification_helper.dart';

part 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionInitialState());

  List<TaskModel> _selectedTasks = [];

  List getSelectedTask() {
    return _selectedTasks;
  }

  //
  Future<void> deleteTasks() async {
    for (int i = 0; i < _selectedTasks.length; i++) {
      await FunctionHelper.withDeleteOperation(_selectedTasks[i]);
    }
    _selectedTasks.forEach((task) {
      task.isSelected = false;
    });
    _selectedTasks.clear();
    // emit(SelectionInitialState());
    emit(DisableSelectionModeState());
  }

  //
  Future<void> markAsFinished() async {
    for (int i = 0; i < _selectedTasks.length; i++) {
      //
      if (_selectedTasks[i].notificationId.isNotEmpty) {
        await NotificationHelper.cancelNotification(
            _selectedTasks[i].notificationId);
      }
      if (_selectedTasks[i].isDone == 'false') {
        final TaskModel updatedTask = TaskModel(
          id: _selectedTasks[i].id,
          title: _selectedTasks[i].title,
          details: _selectedTasks[i].details,
          notificationId: '',
          category: _selectedTasks[i].category,
          date: _selectedTasks[i].date,
          time: _selectedTasks[i].time,
          isDone: 'true',
        );
        await DBHelper.updateValue(DBHelper.tasksTableName, updatedTask);
      }
    }
    //
    _selectedTasks.forEach((task) {
      task.isSelected = false;
    });
    _selectedTasks.clear();
    // emit(SelectionInitialState());
    emit(DisableSelectionModeState());
  }

  //
  Future<void> markAsUnFinished() async {
    //
    for (int i = 0; i < _selectedTasks.length; i++) {
      //
      final editedTask = await FunctionHelper.addOrCancelNotification(
          _selectedTasks[i], false);

      await DBHelper.updateValue(DBHelper.tasksTableName, editedTask);
      //
    }
    //
    _selectedTasks.forEach((task) {
      task.isSelected = false;
    });
    _selectedTasks.clear();
    // emit(SelectionInitialState());
    emit(DisableSelectionModeState());
  }

  //
  Future<void> selectAndDeSelectTask(TaskModel task) async {
    //change task state
    task.isSelected = !task.isSelected;
    if (task.isSelected) {
      _selectedTasks.add(task);
      //just to rebuild again !
      // emit(SelectionInitialState());
      emit(EnableSelectionModeState());
    } else {
      _selectedTasks.remove(task);
      //
      if (_selectedTasks.length == 0) {
        emit(DisableSelectionModeState());
      }
      //if no tasks are selected
      else {
        // emit(SelectionInitialState());
        emit(EnableSelectionModeState());
      }
    }
  }

  //
  Future<void> disableSelectionMode() async {
    _selectedTasks.forEach((task) {
      task.isSelected = false;
    });
    _selectedTasks.clear();
    emit(DisableSelectionModeState());
  }

  //
  Future<void> shareTasks() async {
    String sharedString = '•  ${_selectedTasks[0].title}\n';
    for (int i = 1; i < _selectedTasks.length; i++) {
      sharedString = sharedString + '•  ${_selectedTasks[i].title}\n';
    }
    await Share.share(sharedString);
    _selectedTasks.forEach((task) {
      task.isSelected = false;
    });
    _selectedTasks.clear();
    // emit(SelectionInitialState());
    emit(DisableSelectionModeState());
  }
  //
}
