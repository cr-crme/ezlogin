import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ezlogin_mock.dart';

class LoggedScreen extends StatelessWidget {
  const LoggedScreen({super.key});

  static const routeName = '/logged-screen';
  @override
  Widget build(BuildContext context) {
    final logged = Provider.of<EzloginMock>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Text(
          'You are logged in as: ${logged.currentUser!.firstName}\n'
          'which is a ${logged.currentUser!.userType.name}\nCongrats!',
        ),
      ),
    );
  }
}
