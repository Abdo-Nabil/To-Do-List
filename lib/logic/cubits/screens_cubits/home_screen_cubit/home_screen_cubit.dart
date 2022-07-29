import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/setting_screen/setting_helper.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitialState());

  List _tasks = [];
  List get tasks => _tasks;

  // bool _checkBoxValue = false;
  //
  // void setCheckBoxValue(bool value) {
  //   _checkBoxValue = value;
  // }

  //
  Future<void> updateTaskCardCheckBox(TaskModel task, bool newValue) async {
    final editedTask =
        await FunctionHelper.addOrCancelNotification(task, newValue);

    await DBHelper.updateValue(DBHelper.tasksTableName, editedTask);
    _tasks.remove(task);
  }

  //
  //note: in animated list you must make a delay after progress indicator
  // may be 10 milliseconds to give a time for the animated list to be built
  // unlike the listview.builder
  //
  Future<void> getStartupTasksAndCategory() async {
    emit(HomeScreenLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    //
    final startupCategory = await SettingHelper.getStartupCategory();
    final categoriesList = [CategoryModel.allCategories];
    final categories = await DBHelper.getCategories();
    categoriesList.addAll(categories);
    //
    if (startupCategory == CategoryModel.allCategories.categoryName) {
      _tasks = await DBHelper.getTasks();
      emit(GetAllCategoriesTasksState(
          tasks: _tasks, categories: categoriesList));
    } else {
      _tasks = await DBHelper.getCategoryTasks(startupCategory);
      emit(GetSelectedCategoryTasksState(
        tasks: _tasks,
        categories: categoriesList,
        categoryName: startupCategory,
      ));
    }
  }

  Future<void> getAllCategoriesTasks() async {
    emit(HomeScreenLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    //
    _tasks = await DBHelper.getTasks();
    final categoriesList = [CategoryModel.allCategories];
    final categories = await DBHelper.getCategories();
    categoriesList.addAll(categories);
    emit(
      GetAllCategoriesTasksState(
        tasks: _tasks,
        categories: categoriesList,
      ),
    );
  }

  //
  Future<void> getSelectedCategoryTasks(String categoryName) async {
    emit(HomeScreenLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    //
    _tasks = await DBHelper.getCategoryTasks(categoryName);
    final categoriesList = [CategoryModel.allCategories];
    final categories = await DBHelper.getCategories();
    categoriesList.addAll(categories);
    emit(
      GetSelectedCategoryTasksState(
          tasks: _tasks,
          categories: categoriesList,
          categoryName: categoryName),
    );
  }

  //ToDo: this is very important trick for getting previous state of a screen when navigate to another screen and then return back !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //
  Future<void> getPreviousState(HomeScreenState previousState) async {
    emit(HomeScreenLoadingState());
    await Future.delayed(Duration(milliseconds: k_animated_list_delay));
    //
    _tasks = await DBHelper.getTasks();
    final categoriesList = [CategoryModel.allCategories];
    final categories = await DBHelper.getCategories();
    categoriesList.addAll(categories);
    //
    if (previousState is GetAllCategoriesTasksState) {
      _tasks = await DBHelper.getTasks();
      emit(GetAllCategoriesTasksState(
          tasks: _tasks, categories: categoriesList));
    }
    //
    else if (previousState is GetSelectedCategoryTasksState) {
      //
      List selectedCategory = [];
      for (int i = 0; i < categoriesList.length; i++) {
        if (previousState.categoryName == categoriesList[i].categoryName) {
          selectedCategory.add(categoriesList[i]);
          break;
        }
      }
      //
      if (selectedCategory.length == 0) {
        //that means that the category has been deleted or edited !
        emit(GetAllCategoriesTasksState(
            tasks: _tasks, categories: categoriesList));
      }
      //
      else {
        _tasks =
            await DBHelper.getCategoryTasks(selectedCategory[0].categoryName);
        emit(GetSelectedCategoryTasksState(
            tasks: _tasks,
            categories: categoriesList,
            categoryName: selectedCategory[0].categoryName));
      }
    }
  }
}
