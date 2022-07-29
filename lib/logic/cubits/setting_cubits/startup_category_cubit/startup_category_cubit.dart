import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/ui/setting_screen/setting_helper.dart';

part 'startup_category_state.dart';

class StartupCategoryCubit extends Cubit<StartupCategoryState> {
  StartupCategoryCubit() : super(StartupInitialState());

  Future<List<CategoryModel>> getCategories() async {
    return await DBHelper.getCategories();
  }

  Future<String?> getStartupCategory() async {
    // emit(StartupCategoryLoadingState());
    final defaultStartupCategory = await SettingHelper.getStartupCategory();
    emit(GetStartupCategoryState(defaultStartupCategory));
  }

  Future<void> selectStartupCategory(String categoryName) async {
    // emit(StartupCategoryLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('startupCategory', categoryName);
    emit(GetStartupCategoryState(categoryName));
  }
}
