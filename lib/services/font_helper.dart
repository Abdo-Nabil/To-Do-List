import 'package:flutter/material.dart';

//NOTE THE DIFFERENCE !!
//subtitle2Style means to return subtitle 2 with its style (font size, font weight, spacing, ...)
//but subtitle1Default means that we take the font size only  !!
//
class FontHelper {
  static TextStyle headline6(BuildContext context) {
    return Theme.of(context).textTheme.headline6!;
  }

  static TextStyle subtitle1Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
    );
  }

  static TextStyle subtitle1Bold(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle subtitle1W500(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle subtitle1Normal(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle greySubtitle1Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      color: Colors.grey,
    );
  }

  static TextStyle accentColorSubtitle1Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.headline6!.fontSize,
      color: Theme.of(context).accentColor,
    );
  }

  static TextStyle errorSubtitle1Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      color: Theme.of(context).errorColor,
    );
  }

  static TextStyle subtitle2Style(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2!;
  }

  //default for material Text widget
  static TextStyle bodyText2Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
    );
  }

  static TextStyle errorBodyText2Default(BuildContext context) {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
      color: Theme.of(context).errorColor,
    );
  }
}
