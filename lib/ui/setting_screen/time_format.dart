import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/time_format_cubit/time_format_cubit.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

class TimeFormat extends StatefulWidget {
  @override
  _TimeFormatState createState() => _TimeFormatState();
}

class _TimeFormatState extends State<TimeFormat> {
  @override
  void initState() {
    BlocProvider.of<TimeFormatCubit>(context).getTimeFormat(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    //
    return BlocBuilder<TimeFormatCubit, TimeFormatState>(
      builder: (context, state) {
        if (state is GetTimeFormatState) {
          return ListTile(
            title: Text('Time format'),
            subtitle: Text(state.timeFormat),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Time format'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          3,
                          (index) {
                            return RadioListTile(
                              //selected: false,
                              //selectedTileColor: Colors.grey,
                              title: Text(FunctionHelper.timeFormatList[index]),
                              contentPadding: EdgeInsets.zero,
                              value: FunctionHelper.timeFormatList[index],
                              groupValue: state.timeFormat,
                              //
                              onChanged: (value) async {
                                await BlocProvider.of<TimeFormatCubit>(context)
                                    .selectTimeFormat(
                                  value as String,
                                  context,
                                );
                                //refresh homeScreen instead of restarting the app
                                await BlocProvider.of<HomeScreenCubit>(context)
                                    .getPreviousState(homeScreenPreviousState);
                                Navigator.pop(context);
                              },
                              //
                            );
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
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
