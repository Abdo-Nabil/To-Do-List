import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/ui/setting_screen/setting_helper.dart';
part 'categories_manager_state.dart';

class CategoriesManagerCubit extends Cubit<CategoriesManagerState> {
  CategoriesManagerCubit() : super(CategoriesManagerInitialState());
  //
  List<Map<String, dynamic>> _listOfMaps = [];

  List<Map<String, dynamic>> get listOfMaps => _listOfMaps;
  //
  Future<void> getCategoriesAndTasksNumber() async {
    emit(CategoriesManagerLoadingState());
    List categoriesList = await DBHelper.getCategories();
    _listOfMaps.clear();
    //
    for (int i = 0; i < categoriesList.length; i++) {
      final categoryTasks =
          await DBHelper.getCategoryTasks(categoriesList[i].categoryName);
      _listOfMaps.add({
        'category': categoriesList[i],
        'categoryTasksNumber': categoryTasks.length
      });
    }
    emit(GetCategoriesAndTasksNumberState(_listOfMaps));
  }

  //if u want to edit any thing here, check category_cubit also
  Future<bool> addCategory(CategoryModel categoryModel) async {
    // emit(CategoriesManagerLoadingState());
    //check if category is already exist

    for (int i = 0; i < _listOfMaps.length; i++) {
      if (_listOfMaps[i]['category'].categoryName ==
          categoryModel.categoryName) {
        return true;
      }
    }
    //if category is not exist ==>
    await DBHelper.insertValue(DBHelper.categoriesTableName, categoryModel);

    _listOfMaps.add({
      'category': categoryModel,
      'categoryTasksNumber': 0,
    });
    emit(GetCategoriesAndTasksNumberState(_listOfMaps));
    return false;
  }

  //
  Future<bool> updateCategoryName({
    required CategoryModel newCategoryModel,
    required CategoryModel oldCategoryModel,
  }) async {
    // emit(CategoriesManagerLoadingState());
    //
    //check if the updated category is already exist
    for (int i = 0; i < _listOfMaps.length; i++) {
      if (_listOfMaps[i]['category'].categoryName ==
          newCategoryModel.categoryName) {
        emit(GetCategoriesAndTasksNumberState(_listOfMaps));
        return true;
      }
    }
    //else===>
    await DBHelper.updateValue(DBHelper.categoriesTableName, newCategoryModel);
    //Edit categoryName property in each task
    List tasks = await DBHelper.getCategoryTasks(oldCategoryModel.categoryName);
    //
    for (int i = 0; i < tasks.length; i++) {
      await DBHelper.updateValue(
        DBHelper.tasksTableName,
        TaskModel(
          id: tasks[i].id,
          title: tasks[i].title,
          details: tasks[i].details,
          category: newCategoryModel.categoryName,
          isDone: tasks[i].isDone,
          time: tasks[i].time,
          date: tasks[i].date,
        ),
      );
    }
    //check if the old category was a startup category to edit it.
    await SettingHelper.editSelectedStartupCategory(
      isDeleted: false,
      oldCategoryModel: oldCategoryModel,
      newCategoryModel: newCategoryModel,
    );
    //
    //remove old name and add the new categoryName in _listOfMaps to refresh UI
    for (int i = 0; i < _listOfMaps.length; i++) {
      if (_listOfMaps[i]['category'].categoryName ==
          oldCategoryModel.categoryName) {
        _listOfMaps[i]['category'] = newCategoryModel;
        break;
      }
    }
    emit(GetCategoriesAndTasksNumberState(_listOfMaps));
    return false;
  }

  //
  Future<void> deleteCategory(CategoryModel categoryModel) async {
    // emit(CategoriesManagerLoadingState());
    await DBHelper.deleteValueById(
        DBHelper.categoriesTableName, categoryModel.id);
    // delete tasks of the deleted category
    await DBHelper.deleteCategoryTasks(
      DBHelper.tasksTableName,
      categoryModel.categoryName,
    );

    //remove the category from _listOfMaps to refresh UI
    _listOfMaps.removeWhere(
      (element) {
        return element['category'].id == categoryModel.id;
      },
    );
    //check if the old category was a startup category
    await SettingHelper.editSelectedStartupCategory(
      isDeleted: true,
      oldCategoryModel: categoryModel,
      newCategoryModel: categoryModel,
    );
    //
    emit(GetCategoriesAndTasksNumberState(_listOfMaps));
  }
}
