import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/completed_tasks_cubit/completed_tasks_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/dialog_helper.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomeScreenSelectionAppBar;
  final bool isCompletedTasksScreenSelectionAppBar;
  final bool isSearchScreenSelectionAppBar;

  const SelectionAppBar({
    required this.isHomeScreenSelectionAppBar,
    required this.isCompletedTasksScreenSelectionAppBar,
    required this.isSearchScreenSelectionAppBar,
  });

  //instead of make a separate selection app bar file for each screen
  // we mange them all in one !
  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context, listen: false).state;

    //
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        onPressed: () {
          BlocProvider.of<SelectionCubit>(context).disableSelectionMode();
        },
      ),
      actions: [
        IconButton(
          icon: isCompletedTasksScreenSelectionAppBar
              ? Icon(Icons.check_box_outline_blank_sharp)
              : Icon(Icons.check_box),
          tooltip: isCompletedTasksScreenSelectionAppBar
              ? 'Mark as un-finished'
              : 'Mark as finished',
          onPressed: () async {
            //
            if (isHomeScreenSelectionAppBar) {
              final bool isYes = await DialogHelper.showGeneralDialog(
                  context, 'Mark selected tasks as finished ?');
              if (isYes) {
                await BlocProvider.of<SelectionCubit>(context).markAsFinished();
                //Refresh the home screen list, whatever what it was !!
                await BlocProvider.of<HomeScreenCubit>(context)
                    .getPreviousState(homeScreenPreviousState);
              }
            }
            //
            else if (isCompletedTasksScreenSelectionAppBar) {
              final bool isYes = await DialogHelper.showGeneralDialog(
                  context, 'Mark selected tasks as un-finished ?');
              if (isYes) {
                await BlocProvider.of<SelectionCubit>(context)
                    .markAsUnFinished();
                //refresh completed tasks screen
                await BlocProvider.of<CompletedTasksCubit>(context)
                    .getCompletedTasks();
              }
            }
            //
            else if (isSearchScreenSelectionAppBar) {
              final bool isYes = await DialogHelper.showGeneralDialog(
                  context, 'Mark selected tasks as finished ?');
              if (isYes) {
                await BlocProvider.of<SelectionCubit>(context).markAsFinished();
                //Refresh searching list
                await BlocProvider.of<SearchCubit>(context).getAllTasks();
              }
            }
            //
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          tooltip: 'Share',
          onPressed: () async {
            await BlocProvider.of<SelectionCubit>(context).shareTasks();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Delete',
          onPressed: () async {
            final bool isYes =
                await DialogHelper.showDeleteDialogWithTasksNumber(context);

            //
            if (isYes) {
              await BlocProvider.of<SelectionCubit>(context).deleteTasks();
              //
              if (isHomeScreenSelectionAppBar) {
                //Refresh the home screen list, whatever what it was !!
                await BlocProvider.of<HomeScreenCubit>(context)
                    .getPreviousState(homeScreenPreviousState);
              }
              //
              else if (isCompletedTasksScreenSelectionAppBar) {
                //refresh completed tasks screen
                await BlocProvider.of<CompletedTasksCubit>(context)
                    .getCompletedTasks();
              }
              //
              else if (isSearchScreenSelectionAppBar) {
                //Refresh searching list
                await BlocProvider.of<SearchCubit>(context).getAllTasks();
              }
            }
          },
        ),
      ],
      title: Text(
        BlocProvider.of<SelectionCubit>(context)
            .getSelectedTask()
            .length
            .toString(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
