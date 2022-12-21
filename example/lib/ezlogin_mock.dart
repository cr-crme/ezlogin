import 'package:ezlogin/ezlogin.dart';

import 'my_custom_ezlogin_user.dart';

Map<String, dynamic> defineNewUser(
  EzloginUser user, {
  required String password,
}) =>
    {'user': user, 'password': password};

class EzloginMock with Ezlogin {
  EzloginMock(this.initialDatabase);

  @override
  bool get isLogged => currentUser != null;

  MyCustomEzloginUser? _currentUser;
  @override
  MyCustomEzloginUser? get currentUser => _currentUser;

  @override
  Future<EzloginUser?> user(String username) async {
    if (!_users.containsKey(user)) return null;

    return _users[user]!['user'];
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  final Map<String, dynamic> initialDatabase;
  late Map<String, dynamic> _users = initialDatabase;

  @override
  Future<EzloginStatus> login({
    required String username,
    required String password,
    required Future<EzloginUser?> Function() getNewUserInfo,
    required Future<String?> Function() getNewPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(username)) return EzloginStatus.wrongUsername;

    if (password != _users[username]['password']) {
      return EzloginStatus.wrongPassword;
    }

    return await finalizeLogin(
        username: username,
        getNewUserInfo: getNewUserInfo,
        getNewPassword: getNewPassword);
  }

  @override
  Future<EzloginStatus> logout() async {
    _currentUser = null;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> updatePassword(
      {required EzloginUser user, required String newPassword}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email]!['password'] = newPassword;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> addUser({
    required EzloginUser newUser,
    required String password,
  }) async {
    if (_users.containsKey(newUser.email)) {
      return EzloginStatus.couldNotCreateUser;
    }

    _users[newUser.email] = defineNewUser(newUser, password: password);
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> modifyUser(
      {required EzloginUser user, required EzloginUser newInfo}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email] = newInfo;

    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> deleteUser({required EzloginUser user}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users.remove(user.email);
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> clearUsers() async {
    _users = initialDatabase;
    return EzloginStatus.success;
  }
}
