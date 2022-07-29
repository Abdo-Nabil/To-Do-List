part of 'categories_manager_cubit.dart';

abstract class CategoriesManagerState {
  const CategoriesManagerState();
}

class CategoriesManagerInitialState extends CategoriesManagerState {
  // @override
  // List<Object> get props => [];
}

class CategoriesManagerLoadingState extends CategoriesManagerState {
  // @override
  // List<Object> get props => [];
}

class GetCategoriesAndTasksNumberState extends CategoriesManagerState {
  final List<Map<String, dynamic>> listOfMaps;

  GetCategoriesAndTasksNumberState(this.listOfMaps);

  // @override
  // List<Object?> get props => [listOfMaps];
}
