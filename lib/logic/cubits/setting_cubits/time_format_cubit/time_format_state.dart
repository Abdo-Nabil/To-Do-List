part of 'time_format_cubit.dart';

abstract class TimeFormatState extends Equatable {
  const TimeFormatState();
}

class TimeFormatInitialState extends TimeFormatState {
  @override
  List<Object> get props => [];
}

class TimeFormatLoadingState extends TimeFormatState {
  @override
  List<Object> get props => [];
}

class GetTimeFormatState extends TimeFormatState {
  final String timeFormat;
  GetTimeFormatState(this.timeFormat);

  @override
  List<Object> get props => [timeFormat];
}
