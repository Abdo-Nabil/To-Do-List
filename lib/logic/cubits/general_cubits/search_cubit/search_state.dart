part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchingState extends SearchState {
  final List tasks;
  final String word;
  const SearchingState(
    this.tasks,
    this.word,
  );
  @override
  List<Object> get props => [tasks, word];
}

class GetAllTasksState extends SearchState {
  final List tasks;
  const GetAllTasksState(
    this.tasks,
  );
  @override
  List<Object> get props => [tasks];
}
