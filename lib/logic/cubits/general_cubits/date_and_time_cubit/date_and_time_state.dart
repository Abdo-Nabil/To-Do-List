part of 'date_and_time_cubit.dart';

abstract class DateAndTimeState extends Equatable {
  const DateAndTimeState();
}

class DateAndTimeInitialState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}

class DateAndTimeLoadingState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}

class ShowTimePickerState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}

class HideTimePickerState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}

//used only in edit task screen to check if the task has a time to view or not
class CheckTimePickerState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}

class RefreshTimePickerState extends DateAndTimeState {
  @override
  List<Object> get props => [];
}
