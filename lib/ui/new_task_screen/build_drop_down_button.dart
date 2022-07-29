import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';

class BuildDropDownButton extends StatelessWidget {
  final String dropdownButtonValue;
  final List<CategoryModel> categoryList;

  BuildDropDownButton({
    required this.dropdownButtonValue,
    required this.categoryList,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      menuMaxHeight: 3 * 50,
      value: dropdownButtonValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 8,
      onTap: () {
        //remove any focus from text fields if found
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (newValue) async {
        await BlocProvider.of<CategoryCubit>(context)
            .selectCategory(newValue as String);
      },
      items: categoryList.map<DropdownMenuItem<String>>(
        (CategoryModel value) {
          return DropdownMenuItem<String>(
            value: value.categoryName,
            child: Text(
              value.categoryName,
              overflow: TextOverflow.ellipsis,
              style: FontHelper.subtitle1Default(context),
              // maxLines: 1,
            ),
          );
        },
      ).toList(),
    );
  }
}
