import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/date_helper.dart';

part 'week_starting_day_state.dart';

/*
  -----------------* FROM DATE TIME CLASS *-----------------
  static const int monday = 1;
  static const int tuesday = 2;
  static const int wednesday = 3;
  static const int thursday = 4;
  static const int friday = 5;
  static const int saturday = 6;
  static const int sunday = 7;
  */
class WeekStartingDayCubit extends Cubit<WeekStartingDayState> {
  WeekStartingDayCubit() : super(WeekStartingDayInitialState());

  int _weekStartingDay = 6; //saturday
  int get weekStartingDay => _weekStartingDay;

  Future<void> getSelectedDay() async {
    // emit(WeekStartingDayLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? storedDay = prefs.getInt('weekStartingDay');

    late int day;
    if (storedDay == null) {
      await prefs.setInt('weekStartingDay', _weekStartingDay);
      day = _weekStartingDay;
    } else {
      await prefs.setInt('weekStartingDay', storedDay);
      day = storedDay;
      _weekStartingDay = storedDay;
    }
    final stringDay = DateHelper.convertIntDayToString(day);
    emit(GetSelectedDayState(stringDay));
  }

  Future<void> selectDay(String selectedDay) async {
    // emit(WeekStartingDayLoadingState());
    int day = DateHelper.convertStringDayToInt(selectedDay);
    _weekStartingDay = day;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('weekStartingDay', day);
    emit(GetSelectedDayState(selectedDay));
  }
}
