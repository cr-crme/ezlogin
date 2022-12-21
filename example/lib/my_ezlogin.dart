import 'package:ezlogin/ezlogin.dart';

import 'my_custom_ezlogin_user.dart';

class MyEzlogin extends EzloginMock {
  MyEzlogin(super.initialDatabase);

  @override
  MyCustomEzloginUser? get currentUser =>
      super.currentUser as MyCustomEzloginUser?;
}
