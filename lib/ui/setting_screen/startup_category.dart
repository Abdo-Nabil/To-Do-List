import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/startup_category_cubit/startup_category_cubit.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

class StartupCategory extends StatefulWidget {
  @override
  _StartupCategoryState createState() => _StartupCategoryState();
}

class _StartupCategoryState extends State<StartupCategory> {
  @override
  void initState() {
    BlocProvider.of<StartupCategoryCubit>(context).getStartupCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return BlocBuilder<StartupCategoryCubit, StartupCategoryState>(
      builder: (context, state) {
        if (state is GetStartupCategoryState) {
          return ListTile(
            title: Text(
              'Startup category',
            ),
            subtitle: Text(
              state.categoryName,
            ),
            onTap: () async {
              //
              List<CategoryModel> categoriesList = [
                CategoryModel.allCategories
              ];
              List<CategoryModel> subCategories =
                  await BlocProvider.of<StartupCategoryCubit>(context)
                      .getCategories();
              categoriesList.addAll(
                subCategories,
              );
              //
              await showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    child: AlertDialog(
                      title: Text('Category to show at startup'),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...categoriesList.map(
                                  (category) {
                                    return RadioListTile(
                                      title: Text(category.categoryName),
                                      contentPadding: EdgeInsets.zero,
                                      //selected: false,
                                      //selectedTileColor: Colors.grey,
                                      value: category.categoryName,
                                      groupValue: state.categoryName,
                                      //
                                      onChanged: (value) async {
                                        await BlocProvider.of<
                                                StartupCategoryCubit>(context)
                                            .selectStartupCategory(
                                                value as String);
                                        //refresh homeScreen dropdown button
                                        await BlocProvider.of<HomeScreenCubit>(
                                                context,
                                                listen: false)
                                            .getSelectedCategoryTasks(value);
                                        Navigator.pop(context);
                                      },
                                      //
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
        return ErrorBloc();
      },
    );
  }
}
