import 'package:ezlogin/ezlogin.dart';

import 'my_custom_ezlogin_user.dart';

Map<String, dynamic> defineNewUser(
  EzloginUser user, {
  required String password,
}) =>
    {'user': user, 'password': password};

class MyEzlogin extends EzloginMock {
  MyEzlogin(super.initialDatabase);

  @override
  MyCustomEzloginUser? get currentUser =>
      super.currentUser as MyCustomEzloginUser?;
}
