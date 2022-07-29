part of 'color_palette_cubit.dart';

abstract class ColorPaletteState extends Equatable {
  const ColorPaletteState();
}

class ColorPaletteInitialState extends ColorPaletteState {
  @override
  List<Object> get props => [];
}

// class ColorPaletteLoadingState extends ColorPaletteState {
//   @override
//   List<Object> get props => [];
// }

class GetColorPaletteState extends ColorPaletteState {
  final String colorName;
  final int colorValue;
  GetColorPaletteState(this.colorName, this.colorValue);

  @override
  List<Object> get props => [colorName, colorValue];
}
