import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/function_helper.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  String _searchedWord = '';
  late List _searchedTasks;

  Future<void> updateTask(TaskModel task, bool newValue) async {
    // emit(SearchLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));

    final editedTask =
        await FunctionHelper.addOrCancelNotification(task, newValue);

    await DBHelper.updateValue(DBHelper.tasksTableName, editedTask);
    if (_searchedWord.isEmpty) {
      await Future.delayed(Duration(milliseconds: k_animated_list_delay));
      final List<TaskModel> tasks = await DBHelper.getAllTasks();
      emit(GetAllTasksState(tasks));
    } else {
      emit(SearchingState(_searchedTasks, _searchedWord));
    }
  }

  //
  Future<void> getAllTasks() async {
    emit(SearchLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    final List<TaskModel> tasks = await DBHelper.getAllTasks();
    emit(GetAllTasksState(tasks));
  }

  //
  Future<void> search(String word) async {
    emit(SearchLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    _searchedWord = word;
    final List<TaskModel> tasks = await DBHelper.getAllTasks();
    _searchedTasks = tasks
        .where((task) =>
            task.title.toLowerCase().contains(_searchedWord.toLowerCase()))
        .toList();
    //
    if (_searchedWord.isEmpty) {
      emit(GetAllTasksState(_searchedTasks));
    }
    //
    else {
      emit(SearchingState(_searchedTasks, _searchedWord));
    }
  }

  Future<void> getPreviousState(SearchState previousState) async {
    if (previousState is GetAllTasksState) {
      getAllTasks();
    } else if (previousState is SearchingState) {
      search(_searchedWord);
    }
  }

  //
}
