import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';

class CardCheckBox extends StatefulWidget {
  final TaskModel task;
  final Function onChangeCheckBox;
  final Key key;

  const CardCheckBox({
    required this.task,
    required this.onChangeCheckBox,
    required this.key,
  });

  @override
  _CardCheckBoxState createState() => _CardCheckBoxState();
}

class _CardCheckBoxState extends State<CardCheckBox> {
  //
  bool checkBoxValue = false;

  //
  @override
  void initState() {
    checkBoxValue = widget.task.isDone == 'true' ? true : false;
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    return Checkbox(
      key: widget.key,
      value: checkBoxValue,
      onChanged: (newValue) async {
        checkBoxValue = newValue as bool;
        //Disable selection mode if it was activated
        BlocProvider.of<SelectionCubit>(context).disableSelectionMode();
        setState(() {});
        //refresh ui here with animation based on screen(search screen,completed tasks screen,home screen,....)
        widget.onChangeCheckBox(newValue);
      },
    );
  }
}
