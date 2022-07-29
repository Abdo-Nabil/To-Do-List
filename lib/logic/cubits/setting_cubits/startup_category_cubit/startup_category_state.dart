part of 'startup_category_cubit.dart';

abstract class StartupCategoryState extends Equatable {
  const StartupCategoryState();
}

class StartupInitialState extends StartupCategoryState {
  @override
  List<Object> get props => [];
}

// class StartupCategoryLoadingState extends StartupCategoryState {
//   @override
//   List<Object> get props => [];
// }

class GetStartupCategoryState extends StartupCategoryState {
  final categoryName;
  GetStartupCategoryState(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}
