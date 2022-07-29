import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/constants.dart';
import 'build_picker_row.dart';

class BuildDatePicker extends StatefulWidget {
  final TextEditingController dateController; //initially it is empty string
  final TextEditingController timeController; //initially it is empty string

  const BuildDatePicker({
    required this.dateController,
    required this.timeController,
  });

  @override
  _BuildDatePickerState createState() => _BuildDatePickerState();
}

class _BuildDatePickerState extends State<BuildDatePicker> {
  //
  @override
  Widget build(BuildContext context) {
    //
    //
    Future<DateTime?> openDatePicker() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        //show selected date if it was in EditTaskScreen
        initialDate:
            DateHelper.getDatePickerInitialDate(widget.dateController.text),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        widget.dateController.text = DateHelper.getFormattedString(
            date: pickedDate, formattedString: k_dateFormat);

        //refresh value of dateController that being passed to BuildPickerRow
        setState(() {});

        // refresh time field color in NewTaskScreen and EditTaskScreen, if red date was selected previously
        BlocProvider.of<DateAndTimeCubit>(context).refreshTimePicker();

        //show time picker
        BlocProvider.of<DateAndTimeCubit>(context).showTimePicker();
      }
    }

    //
    return BuildPickerRow(
        onTap: openDatePicker,
        icon: Icons.date_range,
        showRemoveButton: widget.dateController.text.isEmpty ? false : true,
        isDatePicker: true,
        dateController: widget.dateController,
        timeController: widget.timeController,
        onRemove: () {
          widget.dateController.clear();
          widget.timeController.clear();
          setState(() {});
          //hide time picker
          BlocProvider.of<DateAndTimeCubit>(context).hideTimePicker();
        });
  }
}
