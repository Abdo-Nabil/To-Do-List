part of 'font_size_cubit.dart';

abstract class FontSizeState extends Equatable {
  const FontSizeState();
}

class FontSizeInitialState extends FontSizeState {
  @override
  List<Object> get props => [];
}

// class FontSizeLoadingState extends FontSizeState {
//   @override
//   List<Object> get props => [];
// }

class GetFontSizeState extends FontSizeState {
  final String fontSize;
  GetFontSizeState(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}
