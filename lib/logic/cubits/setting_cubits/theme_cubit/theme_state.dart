part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {}

class ThemeInitialState extends ThemeState {
  @override
  List<Object> get props => [];
}

// class ThemeLoadingState extends ThemeState {
//   @override
//   List<Object> get props => [];
// }

class GetThemeState extends ThemeState {
  final String selectedTheme;
  GetThemeState(this.selectedTheme);

  @override
  List<Object> get props => [selectedTheme];
}
