import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'logged_screen.dart';
import 'my_ezlogin.dart';
import 'my_custom_ezlogin_user.dart';

///
/// Here is an dummy database to test. It creates
final Map<String, dynamic> initialDatabase = {
  'super1@user.qc': defineNewUser(
      MyCustomEzloginUser(
        firstName: 'Super',
        lastName: 'One',
        email: 'super1@user.qc',
        shouldChangePassword: false,
        notes: 'This is my second note',
      ),
      password: '123456'),
  'super2@user.qc': defineNewUser(
      MyCustomEzloginUser(
        firstName: 'Super',
        lastName: 'Two',
        email: 'super2@user.qc',
        shouldChangePassword: true,
        notes: 'This is my third note',
      ),
      password: '123456'),
  'normal1@user.qc': defineNewUser(
    MyCustomEzloginUser(
      firstName: 'Normal',
      lastName: 'One',
      email: 'normal1@user.qc',
      shouldChangePassword: false,
      notes: 'This is my forth note',
    ),
    password: '123456',
  ),
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MyEzlogin>(create: (_) => MyEzlogin(initialDatabase))
      ],
      child: MaterialApp(
        title: 'Ezlogin showcase',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: EzlogExampleScreen.routeName,
        routes: {
          EzlogExampleScreen.routeName: (context) =>
              const EzlogExampleScreen(targetRouteName: LoggedScreen.routeName),
          LoggedScreen.routeName: (context) => const LoggedScreen(),
        },
      ),
    );
  }
}
