import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_ezlogin.dart';

class LoggedScreen extends StatelessWidget {
  const LoggedScreen({super.key});

  static const routeName = '/logged-screen';
  @override
  Widget build(BuildContext context) {
    final logged = Provider.of<MyEzlogin>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Text(
          'You are logged in as: '
          '${logged.currentUser!.firstName} ${logged.currentUser!.lastName}\n'
          'Congrats!',
        ),
      ),
    );
  }
}
