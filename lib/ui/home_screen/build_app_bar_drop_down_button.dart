import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';

class BuildAppBarDropDownButton extends StatelessWidget {
  final dropDownValue;
  final List<CategoryModel> items;
  BuildAppBarDropDownButton({
    required this.dropDownValue,
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData themeContext = Theme.of(context);
    return DropdownButton<String>(
      isExpanded: true,
      menuMaxHeight: 4 * 50,
      dropdownColor: Theme.of(context).primaryColor,
      style: TextStyle(
        fontSize: FontHelper.headline6(context).fontSize,
        color: themeContext.colorScheme.onBackground,
      ),
      value: dropDownValue,
      icon: Icon(
        Icons.arrow_drop_down,
        color: themeContext.colorScheme.onBackground,
      ),
      elevation: 8,
      onChanged: (newValue) async {
        //
        if (newValue == 'All Categories') {
          await BlocProvider.of<HomeScreenCubit>(context)
              .getAllCategoriesTasks();
        }
        //
        else {
          await BlocProvider.of<HomeScreenCubit>(context)
              .getSelectedCategoryTasks(newValue as String);
        }
      },
      items: items.map<DropdownMenuItem<String>>(
        (CategoryModel value) {
          return DropdownMenuItem<String>(
            value: value.categoryName,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.categoryName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
