import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';

class BuildTextSeparator extends StatelessWidget {
  final String text;
  const BuildTextSeparator(this.text);

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Text(
      text,
      style: TextStyle(
        fontSize: FontHelper.subtitle1Bold(context).fontSize,
        fontWeight: FontHelper.subtitle1Bold(context).fontWeight,
        color: themeContext.accentColor,
      ),
    );
  }
}
