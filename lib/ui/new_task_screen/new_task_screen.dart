import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/new_task_cubit/new_task_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/notification_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/ui/shared_ui/add_category_button.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:to_do_list/services/id_generator.dart';
import 'build_time_picker.dart';
import 'build_date_picker.dart';
import 'build_drop_down_button.dart';
import 'build_form.dart';
import 'date_rich_text.dart';

class NewTaskScreen extends StatefulWidget {
  static const String routeName = 'NewTaskScreen';

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  //these controllers are passed to other widgets and they may be
  // changed there, these changes appears also here and that is exception
  // for TextEditingController

  //Another solution to avoid initialization and declaration here is to
  // use the trick of passing data back...Do you remember..?
  //
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDetailsController = TextEditingController();
  TextEditingController categoryDialogTextController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  //
  final _formKey = GlobalKey<FormState>();
  //
  late String dropDownButtonValue;
  //
  @override
  void dispose() {
    taskTitleController.dispose();
    taskDetailsController.dispose();
    categoryDialogTextController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context, listen: false).state;
    //
    return WillPopScope(
      onWillPop: () async {
        //
        if (taskTitleController.text.isNotEmpty ||
            taskDetailsController.text.isNotEmpty ||
            dateController.text.isNotEmpty ||
            timeController.text.isNotEmpty) {
          //to hide the key board, try to comment next line and
          // you will see the bug!
          FocusManager.instance.primaryFocus?.unfocus();
          //
          return await DialogHelper.showSaveDialog(context);
        }
        //
        FunctionHelper.refreshHomeScreen(context);
        //
        return true;
      },
      child: GestureDetector(
        //To remove focus from text form fields
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'New Task',
            ),
          ),
          //
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.done),
            tooltip: 'Confirm',
            onPressed: () async {
              final String taskId = IdGenerator.getId();
              int? notificationId; // can be null if no notification created
              //
              final bool isValid = FunctionHelper.validateForm(
                formKey: _formKey,
              );
              if (!isValid) {
                return;
              }

              //
              if (timeController.text.isNotEmpty &&
                  dateController.text.isNotEmpty) {
                //
                notificationId = await DBHelper.getNotificationId();
                final bool isValidDate = DateHelper.combineDateAndTime(
                  date: dateController.text,
                  time: timeController.text,
                  dateParseFormat: k_dateFormat,
                ).isAfter(DateTime.now());

                if (isValidDate) {
                  await NotificationHelper.createNotification(
                    notificationId: notificationId,
                    title: taskTitleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    payLoad: 'oh',
                  );
                }
              }
              //else
              final TaskModel addedTask = TaskModel(
                id: taskId,
                notificationId: notificationId == null ? '' : '$notificationId',
                title: taskTitleController.text,
                category: dropDownButtonValue,
                details: taskDetailsController.text,
                time: timeController.text,
                date: dateController.text,
                //isDone is already false
              );

              await BlocProvider.of<NewTaskCubit>(context).addTask(addedTask);

              //refresh homeScreen
              await BlocProvider.of<HomeScreenCubit>(context)
                  .getPreviousState(homeScreenPreviousState);
              //
              ToastHelper.showToast(context, 'Task added');

              Navigator.of(context).pop();
            },
          ),
          //
          body: Scrollbar(
            isAlwaysShown: true,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BuildForm(
                  formKey: _formKey,
                  taskTitleController: taskTitleController,
                  taskDetailsController: taskDetailsController,
                ),

                ResponsiveSizedBox(heightRatio: 0.03),
                DateRichText(),
                // ResponsiveSizedBox(heightRatio: 0.012),
                BuildDatePicker(
                  timeController: timeController,
                  dateController: dateController,
                ),
                BlocBuilder<DateAndTimeCubit, DateAndTimeState>(
                  builder: (context, state) {
                    if (state is ShowTimePickerState) {
                      return BuildTimePicker(
                        timeController: timeController,
                        dateController: dateController,
                      );
                    }
                    return Container();
                  },
                ),
                ResponsiveSizedBox(heightRatio: 0.03),
                Text(
                  'Category ?',
                  style: FontHelper.subtitle1Bold(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded added to add space between the string and the icon
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              //
                              if (state is GetCategoriesState) {
                                final categoryList = state.categoryList;
                                dropDownButtonValue = state.dropDownButtonValue;
                                return BuildDropDownButton(
                                  dropdownButtonValue: dropDownButtonValue,
                                  categoryList: categoryList,
                                );
                              }
                              //
                              return ErrorBloc();
                            },
                          ),
                        ),
                      ),
                    ),
                    ResponsiveSizedBox(widthRatio: 0.05),
                    AddCategoryButton(),
                  ],
                ),
                ResponsiveSizedBox(heightRatio: 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
