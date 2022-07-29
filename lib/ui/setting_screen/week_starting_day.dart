import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/week_first_day_cubit/week_starting_day_cubit.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

/*
  -----------------* FROM DATE TIME CLASS *-----------------
  static const int saturday = 6;
  static const int sunday = 7;
  static const int monday = 1;
  static const int tuesday = 2;
  static const int wednesday = 3;
  static const int thursday = 4;
  static const int friday = 5;
  */
class WeekStartingDay extends StatefulWidget {
  static const List<String> days = const [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  _WeekStartingDayState createState() => _WeekStartingDayState();
}

class _WeekStartingDayState extends State<WeekStartingDay> {
  @override
  void initState() {
    BlocProvider.of<WeekStartingDayCubit>(context).getSelectedDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    //
    return BlocBuilder<WeekStartingDayCubit, WeekStartingDayState>(
      builder: (context, state) {
        if (state is GetSelectedDayState) {
          return ListTile(
            title: Text('Starting day of the week'),
            subtitle: Text(state.day),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Starting day of the week'),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                7,
                                (index) {
                                  return RadioListTile(
                                    //selected: false,
                                    //selectedTileColor: Colors.grey,
                                    title: Text(WeekStartingDay.days[index]),
                                    contentPadding: EdgeInsets.zero,
                                    value: WeekStartingDay.days[index],
                                    groupValue: state.day,
                                    //
                                    onChanged: (value) async {
                                      await BlocProvider.of<
                                              WeekStartingDayCubit>(context)
                                          .selectDay(value as String);
                                      //refresh homeScreen instead of restarting the app
                                      await BlocProvider.of<HomeScreenCubit>(
                                              context)
                                          .getPreviousState(
                                              homeScreenPreviousState);
                                      Navigator.pop(context);
                                    },
                                    //
                                  );
                                },
                              ),
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
