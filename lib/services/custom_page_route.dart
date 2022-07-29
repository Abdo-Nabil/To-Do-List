import 'package:flutter/material.dart';

//link => https://stackoverflow.com/questions/49874272/how-to-navigate-to-other-page-without-animation-flutter

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(seconds: 0);
}
