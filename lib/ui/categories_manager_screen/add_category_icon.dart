import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/categories_manager_cubit/categories_manager_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/services/id_generator.dart';

class AddCategoryIcon extends StatefulWidget {
  const AddCategoryIcon({Key? key}) : super(key: key);

  @override
  _AddCategoryIconState createState() => _AddCategoryIconState();
}

class _AddCategoryIconState extends State<AddCategoryIcon> {
  TextEditingController categoryNameController = TextEditingController();
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
  //
  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }
  //ToDo: dispose any controller

  @override
  Widget build(BuildContext context) {
    //
    onDialogOkButton() async {
      //
      final homeScreenPreviousState =
          BlocProvider.of<HomeScreenCubit>(context).state;
      final bool isCategoryAlreadyExist =
          await BlocProvider.of<CategoriesManagerCubit>(context).addCategory(
        CategoryModel(
            id: IdGenerator.getId(), categoryName: categoryNameController.text),
      );
      if (isCategoryAlreadyExist) {
        ToastHelper.showToast(context, 'Category is already exist');
      } else {
        ToastHelper.showToast(context, 'Category added');
      }
      //refresh home screen and dropdown button
      await BlocProvider.of<HomeScreenCubit>(context)
          .getPreviousState(homeScreenPreviousState);
      //clean the text field
      categoryNameController.clear();
    }

    //
    Future<void> onPressed() async {
      final bool isAdded = await DialogHelper.showCategoryDialog(
        context: context,
        categoryNameController: categoryNameController,
        title: 'New Category',
        okText: 'Add',
        snackBarMessage: 'Category Added',
        dialogFormKey: dialogFormKey,
      );
      if (isAdded) {
        await onDialogOkButton();
      }
    }

    return IconButton(
      icon: const Icon(Icons.playlist_add_sharp),
      tooltip: 'Add category',
      onPressed: () async {
        await onPressed();
      },
    );
  }
}
