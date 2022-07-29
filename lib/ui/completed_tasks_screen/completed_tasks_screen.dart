import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/completed_tasks_cubit/completed_tasks_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/shared_ui/no_tasks_widget.dart';
import 'package:to_do_list/ui/completed_tasks_screen/bulid_completed_tasks_list.dart';
import 'package:to_do_list/ui/shared_ui/center_progress_indicator.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/get_app_bar.dart';

class CompletedTasksScreen extends StatelessWidget {
  static const String routeName = 'CompletedTasksScreen';

  Widget build(BuildContext context) {
    print('************* built completed screen ***********');
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    //
    BlocProvider.of<CompletedTasksCubit>(context).getCompletedTasks();
    //
    //triggered when backButton pressed (physical button or appBar default button)
    return WillPopScope(
      onWillPop: () async {
        //
        final bool isToGoBAck = FunctionHelper.isToGoBack(context);

        if (isToGoBAck == false) {
          return false;
        }
        await BlocProvider.of<HomeScreenCubit>(context)
            .getPreviousState(homeScreenPreviousState);
        return true;
      },
      child: Scaffold(
        appBar: GetAppBar(
          defaultAppBar: AppBar(
            title: Text('Completed Tasks'),
          ),
          isHomeScreenSelectionAppBar: false,
          isCompletedTasksScreenSelectionAppBar: true,
          isSearchScreenSelectionAppBar: false,
        ),
        //
        body: BlocBuilder<CompletedTasksCubit, CompletedTasksState>(
          builder: (context, state) {
            if (state is CompletedTasksLoadingState) {
              return CenterProgressIndicator();
            }
            //
            else if (state is GetCompletedTasksState) {
              final orderedTasks =
                  FunctionHelper.generateOrderedTasks(state.tasks);

              return orderedTasks.length > 0
                  ? BuildCompletedTasksList(
                      tasks: orderedTasks,
                    )
                  : NoTasksWidget(
                      greyText: 'No tasks in ',
                      boldText: 'Completed Tasks',
                      showImage: false,
                    );
            }
            //
            return ErrorBloc();
          },
        ),
      ),
    );
  }
}
