import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/edit_task_cubit/edit_task_cubit.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/ui/shared_ui/center_progress_indicator.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

class BuildCheckBoxRow extends StatefulWidget {
  final TaskModel task;

  BuildCheckBoxRow(
    this.task,
  );

  @override
  _BuildCheckBoxRowState createState() => _BuildCheckBoxRowState();
}

class _BuildCheckBoxRowState extends State<BuildCheckBoxRow> {
  //
  void getState(bool isChecked) {
    if (isChecked) {
      BlocProvider.of<EditTaskCubit>(context).checkTheBox();
    } else {
      BlocProvider.of<EditTaskCubit>(context).unCheckTheBox();
    }
  }

  //
  @override
  void initState() {
    final isChecked = widget.task.isDone == 'true' ? true : false;
    getState(isChecked);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    final themeContext = Theme.of(context);
    //
    return BlocBuilder<EditTaskCubit, EditTaskState>(
      builder: (context, state) {
        if (state is EditTaskLoadingState) {
          return CenterProgressIndicator();
        }
        //
        else if (state is CheckedBoxState) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Task Finished !',
              style: TextStyle(
                fontSize: FontHelper.subtitle1W500(context).fontSize,
                fontWeight: FontHelper.subtitle1W500(context).fontWeight,
                color: themeContext.accentColor,
              ),
            ),
            value: true,
            onChanged: (value) {
              getState(value!);
            },
          );
        } else if (state is UnCheckedBoxState) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Task Finished ?',
              style: TextStyle(
                fontSize: FontHelper.subtitle1W500(context).fontSize,
                fontWeight: FontHelper.subtitle1W500(context).fontWeight,
                color: themeContext.hintColor,
              ),
            ),
            value: false,
            onChanged: (value) {
              getState(value!);
            },
          );
        }
        return ErrorBloc();
      },
    );
  }
}
