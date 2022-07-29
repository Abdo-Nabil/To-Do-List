part of 'category_cubit.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitialState extends CategoryState {
  // @override
  // List<Object> get props => [];
}

// class CategoryLoadingState extends CategoryState {
//   @override
//   List<Object> get props => [];
// }

class GetCategoriesState extends CategoryState {
  final List<CategoryModel> categoryList;
  final String dropDownButtonValue;
  GetCategoriesState(
    this.categoryList,
    this.dropDownButtonValue,
  );

  // @override
  // List<Object> get props => [categoryList, dropDownButtonValue];
}
