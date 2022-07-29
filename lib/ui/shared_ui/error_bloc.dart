import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';

class ErrorBloc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Sorry for that, but some thing went wrong, please report the problem.',
            style: TextStyle(
              fontSize: FontHelper.subtitle1Bold(context).fontSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
