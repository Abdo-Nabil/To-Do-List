import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/categories_manager_cubit/categories_manager_cubit.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/categories_manager_screen/add_category_icon.dart';
import 'package:to_do_list/ui/shared_ui/center_progress_indicator.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'category_card.dart';

class CategoriesManagerScreen extends StatelessWidget {
  //
  static const String routeName = 'CategoriesManagerScreen';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //
    FunctionHelper.refreshHomeScreen(context);
    //
    BlocProvider.of<CategoriesManagerCubit>(context)
        .getCategoriesAndTasksNumber();
    //
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Categories Manager'),
        actions: [
          const AddCategoryIcon(),
        ],
      ),
      //
      body: BlocBuilder<CategoriesManagerCubit, CategoriesManagerState>(
        builder: (context, state) {
          if (state is CategoriesManagerLoadingState) {
            return const CenterProgressIndicator();
          }
          //
          else if (state is GetCategoriesAndTasksNumberState) {
            final listOfMaps = state.listOfMaps;
            return Scrollbar(
              // isAlwaysShown: true,
              child: ListView.builder(
                itemCount: listOfMaps.length,
                itemBuilder: (context, index) {
                  //
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      index == 0 ? 6 : 0,
                      0,
                      0,
                    ),
                    child: CategoryCard(
                      category: listOfMaps[index]['category'],
                      tasksNumber: listOfMaps[index]['categoryTasksNumber'],
                      pageContext: _scaffoldKey.currentContext!,
                    ),
                  );
                },
              ),
            );
          }
          return ErrorBloc();
        },
      ),
    );
  }
}
