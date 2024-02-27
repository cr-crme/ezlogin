import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezlogin/ezlogin.dart';

import 'login_screen.dart';
import 'logged_screen.dart';
import 'my_ezlogin.dart';
import 'my_custom_ezlogin_user.dart';

///
/// Here is an dummy database to test. It populates the data base with the
/// required data type. The two users we are creating here are
/// `user1@user.qc` and `user2@user.qc` with both `123456` as password
///
final Map<String, dynamic> initialDatabase = {
  'user1@user.qc': userForEzloginMock(
    user: MyCustomEzloginUser(
      firstName: 'Super',
      lastName: 'One',
      email: 'user1@user.qc',
      mustChangePassword: false,
    ),
    password: '123456',
  ),
  'user2@user.qc': userForEzloginMock(
    user: MyCustomEzloginUser(
      firstName: 'Super',
      lastName: 'Two',
      email: 'user2@user.qc',
      mustChangePassword: true,
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
