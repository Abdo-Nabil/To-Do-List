import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';

class DeleteIconButton extends StatelessWidget {
  final TaskModel task;
  const DeleteIconButton(this.task);

  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context, listen: false).state;
    //
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Delete',
      onPressed: () async {
        bool isDeleted = await DialogHelper.showDeleteDialog(
          context: context,
        );
        if (isDeleted) {
          await FunctionHelper.withDeleteOperation(task);

          //Refresh the list, whatever what it was !!
          await BlocProvider.of<HomeScreenCubit>(context)
              .getPreviousState(homeScreenPreviousState);
          ToastHelper.showToast(context, 'Task deleted');
          //
          Navigator.pop(context);
        }
      },
    );
  }
}
