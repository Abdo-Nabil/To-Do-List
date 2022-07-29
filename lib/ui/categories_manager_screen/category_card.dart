import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/categories_manager_cubit/categories_manager_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/ui/home_screen/home_screen.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final int tasksNumber;
  final BuildContext pageContext;
  const CategoryCard({
    required this.category,
    required this.tasksNumber,
    required this.pageContext,
  });

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  //
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  //
  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final pageContext = widget.pageContext;
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context, listen: false).state;
    //
    final CategoryModel oldCategoryModel = widget.category;
    //
    Future<void> onEditDialogOkButton() async {
      //
      final bool isCategoryAlreadyExist =
          await BlocProvider.of<CategoriesManagerCubit>(context)
              .updateCategoryName(
        newCategoryModel: CategoryModel(
          id: oldCategoryModel.id,
          categoryName: categoryNameController.text,
        ),
        oldCategoryModel: oldCategoryModel,
      );
      //from here context is no longer exist because we emit a new state which changes the context
      //so we will use pageContext from CategoriesManagerScreen
      if (isCategoryAlreadyExist) {
        ToastHelper.showToast(pageContext, 'Category name is already exist');
      } else {
        ToastHelper.showToast(pageContext, 'Category name edited');
      }
      //
      // refresh or edit Tasks of HomeScreen
      if (homeScreenPreviousState is GetAllCategoriesTasksState) {
        await BlocProvider.of<HomeScreenCubit>(pageContext)
            .getAllCategoriesTasks();
      } else if (homeScreenPreviousState.props.length == 3) {
        if (homeScreenPreviousState.props[1] == oldCategoryModel.categoryName) {
          await BlocProvider.of<HomeScreenCubit>(pageContext)
              .getSelectedCategoryTasks(categoryNameController.text);
        } else {
          await BlocProvider.of<HomeScreenCubit>(pageContext)
              .getSelectedCategoryTasks(
                  homeScreenPreviousState.props[1].toString());
        }
      }
    }

    //
    Future<void> onEdit() async {
      //put the current value in textField
      categoryNameController.text = oldCategoryModel.categoryName;
      final bool isEdited = await DialogHelper.showCategoryDialog(
        context: context,
        categoryNameController: categoryNameController,
        title: 'Edit Category',
        okText: 'Edit',
        snackBarMessage: 'Category Edited',
        dialogFormKey: dialogFormKey,
      );
      if (isEdited) {
        await onEditDialogOkButton();
      }
    }

    //
    Future<void> onDelete() async {
      final bool isDeleted = await DialogHelper.showDeleteDialog(
        context: context,
        content: 'All tasks of the category will also be deleted.',
      );
      if (isDeleted) {
        //delete the category
        await BlocProvider.of<CategoriesManagerCubit>(context)
            .deleteCategory(widget.category);
        //from here context is no longer exist be cause we emit a new state which changes the context
        //so we will use pageContext from CategoriesManagerScreen

        ToastHelper.showToast(pageContext, 'Category deleted');
        // refresh or delete Tasks of HomeScreen
        if (homeScreenPreviousState is GetAllCategoriesTasksState) {
          BlocProvider.of<HomeScreenCubit>(pageContext).getAllCategoriesTasks();
        } else if (homeScreenPreviousState.props.length == 3) {
          if (homeScreenPreviousState.props[1] ==
              oldCategoryModel.categoryName) {
            BlocProvider.of<HomeScreenCubit>(pageContext)
                .getStartupTasksAndCategory();
          } else {
            BlocProvider.of<HomeScreenCubit>(pageContext)
                .getSelectedCategoryTasks(
                    homeScreenPreviousState.props[1].toString());
          }
        }
      }
    }

    return InkWell(
      onTap: () {
        BlocProvider.of<HomeScreenCubit>(context)
            .getSelectedCategoryTasks(widget.category.categoryName);

        //ToDo : note the the navigation way , here it must be like that
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return HomeScreen(isPopped: false);
            },
          ),
        );
        //
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Column(
                  //ToDo: Note mainAxisSize, try to remove it
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ResponsiveSizedBox(
                      heightRatio: 0.015,
                    ),
                    Text(
                      widget.category.categoryName,
                      style: FontHelper.subtitle1W500(context),
                      overflow: TextOverflow.ellipsis,
                      //maxLines: 2, note !
                    ),
                    ResponsiveSizedBox(
                      heightRatio: 0.010,
                    ),
                    Text(
                      widget.tasksNumber > 0
                          ? 'Tasks : ${widget.tasksNumber}'
                          : 'No tasks',
                      style: FontHelper.bodyText2Default(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveSizedBox(
                      heightRatio: 0.015,
                    ),
                  ],
                ),
              ),
            ),
            //
            widget.category.categoryName == CategoryModel.getDefaultCategory
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () async {
                            await onEdit();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                          color: Theme.of(context).errorColor,
                          onPressed: () async {
                            await onDelete();
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
