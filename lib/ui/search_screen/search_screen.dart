import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/search_screen/search_app_bar.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/get_app_bar.dart';
import 'build_search_tasks_list.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = 'SearchScreen';

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchCubit>(context).getAllTasks();
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    final ThemeData themeContext = Theme.of(context);
    //
    return WillPopScope(
      onWillPop: () async {
        final bool isToGoBack = FunctionHelper.isToGoBack(context);
        if (isToGoBack) {
          //close keyboard first and wait  25 milliseconds
          FocusScope.of(context).unfocus();
          await Future.delayed(Duration(milliseconds: 25));
          await BlocProvider.of<HomeScreenCubit>(context)
              .getPreviousState(homeScreenPreviousState);
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: GetAppBar(
          defaultAppBar: SearchAppBar(),
          isHomeScreenSelectionAppBar: false,
          isCompletedTasksScreenSelectionAppBar: false,
          isSearchScreenSelectionAppBar: true,
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            //
            if (state is SearchLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //
            else if (state is GetAllTasksState) {
              final orderedTasks =
                  FunctionHelper.generateOrderedTasks(state.tasks);
              return BuildSearchTasksList(
                tasks: orderedTasks,
              );
            }
            //
            else if (state is SearchingState) {
              final orderedTasks =
                  FunctionHelper.generateOrderedTasks(state.tasks);
              return orderedTasks.length > 0
                  ? BuildSearchTasksList(
                      tasks: orderedTasks,
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text.rich(
                          TextSpan(
                            text: state.word,
                            style: TextStyle(
                              fontSize: FontHelper.headline6(context).fontSize,
                              fontWeight: FontWeight.w700,
                              color: themeContext.accentColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' not found',
                                style: TextStyle(
                                  fontSize:
                                      FontHelper.headline6(context).fontSize,
                                  fontWeight: FontWeight.normal,
                                  color: themeContext.hintColor,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
            }
            return ErrorBloc();
          },
        ),
      ),
    );
  }
}
