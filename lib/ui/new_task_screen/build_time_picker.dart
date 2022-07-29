import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/time_format_cubit/time_format_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'build_picker_row.dart';

class BuildTimePicker extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  const BuildTimePicker({
    required this.dateController,
    required this.timeController,
  });

  @override
  _BuildTimePickerState createState() => _BuildTimePickerState();
}

class _BuildTimePickerState extends State<BuildTimePicker> {
  //
  @override
  Widget build(BuildContext context) {
    //
    //
    Future<TimeOfDay?> openTimePicker() async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        //show selected time if it was in EditTaskScreen
        initialTime:
            DateHelper.getTimePickerInitialTime(widget.timeController.text),
        builder: (context, childWidget) {
          return MediaQuery(
            child: childWidget!,
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat:
                  BlocProvider.of<TimeFormatCubit>(context).is24HourFormat,
            ),
          );
        },
      );
      if (pickedTime != null) {
        final bool is24HourFormat =
            BlocProvider.of<TimeFormatCubit>(context).is24HourFormat;

        widget.timeController.text =
            MaterialLocalizations.of(context).formatTimeOfDay(
          pickedTime,
          alwaysUse24HourFormat: is24HourFormat,
        );
        //refresh value of TimeController that being passed to BuildPickerRow
        setState(() {});
      }
    }

    return BlocBuilder<DateAndTimeCubit, DateAndTimeState>(
      builder: (context, state) {
        if (state is RefreshTimePickerState) {
          return BuildPickerRow(
            onTap: openTimePicker,
            icon: Icons.access_time,
            showRemoveButton: true,
            isDatePicker: false,
            dateController: widget.dateController,
            timeController: widget.timeController,
            onRemove: () {
              widget.timeController.clear();
              setState(() {});
            },
          );
        }
        return BuildPickerRow(
          onTap: openTimePicker,
          icon: Icons.access_time,
          showRemoveButton: true,
          isDatePicker: false,
          dateController: widget.dateController,
          timeController: widget.timeController,
          onRemove: () {
            widget.timeController.clear();
            setState(() {});
          },
        );
      },
    );
  }
}
