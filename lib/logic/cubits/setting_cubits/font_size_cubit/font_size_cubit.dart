import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/function_helper.dart';

part 'font_size_state.dart';

class FontSizeCubit extends Cubit<FontSizeState> {
  FontSizeCubit() : super(FontSizeInitialState());

  //-------------------* const *---------------------------
  String systemDefaultPhrase = FunctionHelper.fontSizeList[0];
  String largeFontPhrase = FunctionHelper.fontSizeList[1];
  String smallFontPhrase = FunctionHelper.fontSizeList[2];

  static const double normalFactor = 1.0;
  static const double largeFactor = 1.3;
  static const double smallFactor = 0.85;
  //-------------------------------------------------------

  double? _fontSizeFactor;
  double? get fontSizeFactor => _fontSizeFactor;

  Future<void> getFontSize() async {
    // emit(FontSizeLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? fontSizeFactor = prefs.getDouble('fontSizeFactor');
    //null check performed in the app main function, so it will not be null !
    late String phrase;

    if (fontSizeFactor == normalFactor) {
      phrase = systemDefaultPhrase;
    } else if (fontSizeFactor == largeFactor) {
      phrase = largeFontPhrase;
    } else {
      phrase = smallFontPhrase;
    }
    emit(GetFontSizeState(phrase));
  }

  Future<void> selectFontSize(String selectedFont) async {
    // emit(FontSizeLoadingState());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedFont == systemDefaultPhrase) {
      _fontSizeFactor = normalFactor;
      await prefs.setDouble('fontSizeFactor', normalFactor);
    } else if (selectedFont == largeFontPhrase) {
      _fontSizeFactor = largeFactor;
      await prefs.setDouble('fontSizeFactor', largeFactor);
    } else {
      _fontSizeFactor = smallFactor;
      await prefs.setDouble('fontSizeFactor', smallFactor);
    }

    emit(GetFontSizeState(selectedFont));
  }
}
