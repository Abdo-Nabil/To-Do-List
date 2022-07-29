import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/ui/shared_ui/center_progress_indicator.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'build_app_bar_drop_down_button.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return DropdownButtonHideUnderline(
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          if (state is HomeScreenLoadingState) {
            return CenterProgressIndicator();
          }
          //
          else if (state is GetAllCategoriesTasksState) {
            //
            final List<CategoryModel> items = state.categories;
            var dropDownValue = CategoryModel.allCategories.categoryName;
            return BuildAppBarDropDownButton(
              dropDownValue: dropDownValue,
              items: items,
            );
          }
          //
          else if (state is GetSelectedCategoryTasksState) {
            //
            final List<CategoryModel> items = state.categories;
            var dropDownValue = state.categoryName;
            return BuildAppBarDropDownButton(
              dropDownValue: dropDownValue,
              items: items,
            );
          }

          return ErrorBloc();
        },
      ),
    );
  }
}
