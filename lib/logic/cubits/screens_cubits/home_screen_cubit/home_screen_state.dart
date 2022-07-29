part of 'home_screen_cubit.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();
}

class HomeScreenInitialState extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class HomeScreenLoadingState extends HomeScreenState {
  @override
  List<Object?> get props => [];
}

class GetAllCategoriesTasksState extends HomeScreenState {
  final List tasks;
  final List<CategoryModel> categories;
  const GetAllCategoriesTasksState({
    required this.tasks,
    required this.categories,
  });
  @override
  List<Object> get props => [tasks, categories];
}

class GetSelectedCategoryTasksState extends HomeScreenState {
  final List tasks;
  final String categoryName;
  final List<CategoryModel> categories;

  const GetSelectedCategoryTasksState({
    required this.tasks,
    required this.categoryName,
    required this.categories,
  });

  @override
  List<Object> get props => [tasks, categoryName, categories];
}
