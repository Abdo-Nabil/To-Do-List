part of 'week_starting_day_cubit.dart';

abstract class WeekStartingDayState extends Equatable {
  const WeekStartingDayState();
}

class WeekStartingDayInitialState extends WeekStartingDayState {
  @override
  List<Object> get props => [];
}

// class WeekStartingDayLoadingState extends WeekStartingDayState {
//   @override
//   List<Object> get props => [];
// }

class LoadingState extends WeekStartingDayState {
  @override
  List<Object> get props => [];
}

class GetSelectedDayState extends WeekStartingDayState {
  final String day;
  GetSelectedDayState(this.day);
  @override
  List<Object> get props => [day];
}
