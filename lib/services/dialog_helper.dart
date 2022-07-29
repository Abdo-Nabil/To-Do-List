import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'font_helper.dart';
import 'function_helper.dart';

class DialogHelper {
  //ToDo : it is your choice => barrierDismissible: false, // user must tap button!

  static Future<bool> showGeneralDialog(
      BuildContext context, String bodyText) async {
    bool returnedValue = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure ?'),
        content: Text(bodyText),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = true;
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }

  static Future<bool> showSaveDialog(BuildContext context) async {
    bool returnedValue = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure ?'),
        content: Text('Quit without saving ?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = true;
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }

  static Future<bool> showDeleteDialog({
    required BuildContext context,
    String? content,
  }) async {
    bool returnedValue = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure ?'),
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = true;
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }

  static Future showDeleteDialogWithTasksNumber(BuildContext context) async {
    //
    bool returnedValue = false;
    await showDialog(
        context: context,
        builder: (context) {
          final tasksNumber =
              BlocProvider.of<SelectionCubit>(context).getSelectedTask().length;
          return AlertDialog(
            title: Text('Are you sure ?'),
            content: tasksNumber > 1
                ? Text('Delete tasks ($tasksNumber) ?')
                : Text('Delete task ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  returnedValue = false;
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  returnedValue = true;
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
    return returnedValue;
  }

  static Future<bool> showCategoryDialog({
    required BuildContext context,
    required TextEditingController categoryNameController,
    required String title,
    required String okText,
    required String snackBarMessage,
    required GlobalKey<FormState> dialogFormKey,
  }) async {
    //
    bool isValid() {
      final bool isValid = FunctionHelper.validateForm(
        formKey: dialogFormKey,
      );
      return isValid;
    }

    //
    bool returnedValue = false;
    //note: auto selection !! by opening the dialog
    categoryNameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: categoryNameController.text.length,
    );
    //
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Form(
          key: dialogFormKey,
          child: TextFormField(
            autofocus: true,
            style: FontHelper.bodyText2Default(context),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              errorStyle: TextStyle(
                  fontSize: FontHelper.subtitle2Style(context).fontSize),
              hintText: 'Enter Category Name',
            ),
            controller: categoryNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category name.';
              }
              return null;
            },
            //if '✔' pressed from keyboard
            onFieldSubmitted: (_) {
              if (isValid()) {
                Navigator.pop(context);
                returnedValue = true;
              }
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              //categoryNameController.clear();
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
          TextButton(
            child: Text(okText),
            onPressed: () {
              if (isValid()) {
                Navigator.pop(context);
                returnedValue = true;
              }
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }
}

/*
  static Future<bool> showRestartDialog(BuildContext context) async {
    bool returnedValue = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Warning !'),
        content: Text(
            'Changing time format may require restarting the app to work properly !'),
        actions: <Widget>[
          TextButton(
            child: Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }
  */
/*
  static Future<bool> showExitDialog(BuildContext context) async {
    bool returnedValue = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure ?'),
        content: Text('Do you want to exit the App ?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = false;
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              returnedValue = true;
            },
          ),
        ],
      ),
    );
    return returnedValue;
  }
  */
