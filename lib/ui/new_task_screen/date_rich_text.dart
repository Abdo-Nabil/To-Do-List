import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';

class DateRichText extends StatelessWidget {
  const DateRichText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Date ',
        style: FontHelper.subtitle1Bold(context),
        children: <TextSpan>[
          TextSpan(
            text: '(optional)',
            style: FontHelper.subtitle1Normal(context),
          )
        ],
      ),
    );
  }
}
