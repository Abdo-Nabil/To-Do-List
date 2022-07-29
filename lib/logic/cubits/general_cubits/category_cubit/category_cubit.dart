import 'package:bloc/bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/services/db_helper.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState());

  List<CategoryModel> _categoriesList = [];
  List<CategoryModel> categoriesList() => _categoriesList;

  //if u want to edit any thing here, check categories_manager_cubit also
  Future<bool> addCategory(CategoryModel categoryModel) async {
    // emit(CategoryLoadingState());
    //check if category is already exist
    for (int i = 0; i < _categoriesList.length; i++) {
      if (_categoriesList[i].categoryName == categoryModel.categoryName) {
        return true;
      }
    }
    //if category is not exist ==>
    await DBHelper.insertValue(DBHelper.categoriesTableName, categoryModel);
    _categoriesList.add(categoryModel);
    emit(GetCategoriesState(_categoriesList, categoryModel.categoryName));
    return false;
  }

  //
  Future<void> selectCategory(String selectedCategory) async {
    // emit(CategoryLoadingState());
    _categoriesList = await DBHelper.getCategories();
    emit(GetCategoriesState(_categoriesList, selectedCategory));
  }
  //

}
