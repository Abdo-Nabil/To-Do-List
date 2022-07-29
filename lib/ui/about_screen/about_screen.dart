import 'package:flutter/material.dart';
import 'package:to_do_list/services/constants.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = 'AboutScreen';
  final String appVersion;
  const AboutScreen({
    required this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    //
    FunctionHelper.refreshHomeScreen(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        children: [
          ResponsiveSizedBox(
            heightRatio: 0.04,
          ),
          Image.asset(
            'lib/assets/images/launcher_icon.png',
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          ListTile(
            title: Text('Version'),
            subtitle: Text(
              appVersion,
            ),
          ),
          ListTile(
            title: Text('Developed by'),
            subtitle: Text(
              'Abdo Nabil',
            ),
            onTap: () async {
              await FunctionHelper.getContactDialog(context);
            },
            trailing: ElevatedButton(
              child: Text('Contact'),
              onPressed: () async {
                await FunctionHelper.getContactDialog(context);
              },
            ),
          ),
          ListTile(
            title: Text('Thanks for'),
            subtitle: Text(
              'Ammar Younes',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final url = 'mailto:$ammarEmail?subject=Contact Request';
              await FunctionHelper.launchUrl(url, context);
            },
            trailing: ElevatedButton(
              child: Text('Contact'),
              onPressed: () async {
                final url = 'mailto:$ammarEmail?subject=Contact Request';
                await FunctionHelper.launchUrl(url, context);
              },
            ),
          ),
          ListTile(
            title: Text('Launcher icon'),
            subtitle: Text(
              'made by Freepik from www.flaticon.com',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
