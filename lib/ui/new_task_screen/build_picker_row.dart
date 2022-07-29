import 'package:flutter/material.dart';
import 'package:to_do_list/services/date_helper.dart';

class BuildPickerRow extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final bool showRemoveButton;
  final bool isDatePicker;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function onRemove;
  const BuildPickerRow({
    required this.onTap,
    required this.icon,
    required this.showRemoveButton,
    required this.isDatePicker,
    required this.dateController,
    required this.timeController,
    required this.onRemove,
  });
  //note:
  // the received dateController or timeController
  // are empty or have a date or time value.

  @override
  Widget build(BuildContext context) {
    //
    final List dateAndStyleList = DateHelper.getDateAndStyle(
      givenDate: dateController.text,
      context: context,
    );
    //
    final List timeAndStyleList = DateHelper.getTimeAndStyle(
      givenTime: timeController.text,
      givenDate: dateController.text,
      context: context,
    );
    //
    return InkWell(
      onTap: () {
        //remove any focus from text fields if found
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: isDatePicker
                  ? Text(
                      dateAndStyleList[0],
                      style: dateAndStyleList[1],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      timeAndStyleList[0],
                      style: timeAndStyleList[1],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
            ),
          ),
          showRemoveButton
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Icon(
                      Icons.highlight_remove_outlined,
                    ),
                    onTap: () {
                      onRemove();
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
