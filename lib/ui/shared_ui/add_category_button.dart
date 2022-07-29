import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/services/id_generator.dart';

class AddCategoryButton extends StatefulWidget {
  @override
  _AddCategoryButtonState createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<AddCategoryButton> {
  //
  TextEditingController categoryNameController = TextEditingController();
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
  //
  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    onDialogOkButton() async {
      //
      final bool isCategoryAlreadyExist =
          await BlocProvider.of<CategoryCubit>(context).addCategory(
        CategoryModel(
            id: IdGenerator.getId(), categoryName: categoryNameController.text),
      );
      if (isCategoryAlreadyExist) {
        ToastHelper.showToast(context, 'Category is already exist');
      } else {
        ToastHelper.showToast(context, 'Category added');
      }
      //clean the dialog text field
      categoryNameController.clear();
    }

    //
    Future<void> onPressed() async {
      //remove any focus from text fields if found
      FocusManager.instance.primaryFocus?.unfocus();
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

    return ElevatedButton(
      child: Text(
        'Add New Category',
        style: FontHelper.bodyText2Default(context),
      ),
      onPressed: () async {
        await onPressed();
      },
    );
  }
}
