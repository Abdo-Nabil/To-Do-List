import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/theme_cubit/theme_cubit.dart';
import 'package:to_do_list/services/my_themes.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

class AppThemeMode extends StatefulWidget {
  const AppThemeMode({Key? key}) : super(key: key);

  @override
  _AppThemeModeState createState() => _AppThemeModeState();
}

class _AppThemeModeState extends State<AppThemeMode> {
  @override
  void initState() {
    BlocProvider.of<ThemeCubit>(context).getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (state is GetThemeState) {
          return ListTile(
            title: Text('Theme mode'),
            subtitle: Text(state.selectedTheme),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Theme mode'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          3,
                          (index) {
                            return RadioListTile<String>(
                              //selected: false,
                              //selectedTileColor: Colors.grey,
                              title: Text(MyThemes.themeModeList[index]),
                              contentPadding: EdgeInsets.zero,
                              value: MyThemes.themeModeList[index],
                              groupValue: state.selectedTheme,
                              //
                              onChanged: (value) async {
                                await BlocProvider.of<ThemeCubit>(context)
                                    .selectThemeMode(value as String);
                                Navigator.pop(context);
                              },
                              //
                            );
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
        }
        return ErrorBloc();
      },
    );
  }
}
