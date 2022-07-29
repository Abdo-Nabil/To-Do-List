part of 'completed_tasks_cubit.dart';

abstract class CompletedTasksState extends Equatable {
  const CompletedTasksState();
}

class CompletedTasksInitialState extends CompletedTasksState {
  @override
  List<Object> get props => [];
}

class CompletedTasksLoadingState extends CompletedTasksState {
  @override
  List<Object> get props => [];
}

class GetCompletedTasksState extends CompletedTasksState {
  final List tasks;
  const GetCompletedTasksState(
    this.tasks,
  );
  @override
  List<Object> get props => [tasks];
}
