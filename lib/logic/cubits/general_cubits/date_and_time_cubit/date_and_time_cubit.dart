import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'date_and_time_state.dart';

class DateAndTimeCubit extends Cubit<DateAndTimeState> {
  DateAndTimeCubit() : super(DateAndTimeInitialState());

  void showTimePicker() {
    emit(ShowTimePickerState());
  }

  void hideTimePicker() {
    emit(HideTimePickerState());
  }

  //used in EditTaskScreen to show TimePicker or no based on : if the date picker has a value
  void checkTimePicker() {
    emit(CheckTimePickerState());
  }

  void refreshTimePicker() {
    emit(RefreshTimePickerState());
  }
}
