part of 'new_task_cubit.dart';

abstract class NewTaskState extends Equatable {
  const NewTaskState();
}

class NewTaskInitialState extends NewTaskState {
  @override
  List<Object> get props => [];
}

class NewTaskLoadingState extends NewTaskState {
  @override
  List<Object> get props => [];
}
