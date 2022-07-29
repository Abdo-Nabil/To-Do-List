import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';

class BuildForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController taskTitleController;
  final TextEditingController taskDetailsController;
  final bool isFocused;

  const BuildForm({
    required this.formKey,
    required this.taskTitleController,
    required this.taskDetailsController,
    this.isFocused = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'What is to be done ? ',
              style: FontHelper.subtitle1Bold(context),
              children: <TextSpan>[
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autofocus: isFocused,
              style: FontHelper.bodyText2Default(context),
              //maxLines: null,
              // maxLines: 5,
              // minLines: 1,
              //keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                errorStyle: TextStyle(
                  fontSize: FontHelper.subtitle2Style(context).fontSize,
                ),
                hintText: 'Enter Task Here',
              ),
              controller: taskTitleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter task name.';
                }
                return null;
              },
            ),
          ),
          ResponsiveSizedBox(heightRatio: 0.03),
          Text.rich(
            TextSpan(
              text: 'Details ',
              style: FontHelper.subtitle1Bold(context),
              children: <TextSpan>[
                TextSpan(
                  text: '(optional)',
                  style: FontHelper.subtitle1Normal(context),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: FontHelper.bodyText2Default(context),
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: taskDetailsController,
            ),
          ),
        ],
      ),
    );
  }
}
